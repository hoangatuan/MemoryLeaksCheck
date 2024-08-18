//
//  File.swift
//  
//
//  Created by Tuan Hoang on 6/1/24.
//

import Foundation
import ShellOut

enum LeaksCheckError: Error {
    case leaksCommandFailed
    case incorectOutputFormat
}

struct CheckLeaks: RunCommandStep {
    let executor: Executor

    private let regex: String = ".*(\\d+) leaks for (\\d+) total leaked bytes.*"

    func run() throws {
        
        if executor.memgraphPaths().isEmpty {
            log(message: "❌ Can not find any memgraphs!", color: .red)
            return
        }
        
        for memgraphPath in executor.memgraphPaths() {
            do {
                log(message: "Start checking for leaks... ⚙️")

                /// Running this script always throw error (somehow the leak tool throw error here) => So we need to process the memgraph in the `catch` block.
                try shellOut(to: "leaks", arguments: ["\(memgraphPath) -q"])
            } catch {
                let error = error as! ShellOutError
                if error.output.isEmpty {
                    log(message: "❌ Leaks command run failed! Please open an issue on Github for me to check!", color: .red)
                    throw LeaksCheckError.leaksCommandFailed
                }

                let inputs = error.output.components(separatedBy: "\n")
                guard let numberOfLeaksMessage = inputs.first(where: { $0.matches(regex) }) else {
                    log(message: "❌ Generated leaks output is incorrect! Please open an issue on Github for me to check!", color: .red)
                    throw LeaksCheckError.incorectOutputFormat
                }

                let numberOfLeaks = getNumberOfLeaks(from: numberOfLeaksMessage)

                if numberOfLeaks < 1 {
                    log(message: "Scan successfully. Don't find any leaks in the program! ✅", color: .green)
                    return
                }

                for message in inputs {
                    let updatedMessage = "\"\(message)\""
                    try shellOut(to: "echo \(updatedMessage) >> \(Constants.leaksReportFileName)")
                }

                log(message: "Founded leaks. Generating reports... ⚙️")
            }
        }
    }
    
    private func getMemgraphsURLs() -> [URL] {
        let fileManager = FileManager.default
        var memgraphFiles: [URL] = []
        
        do {
            // Get the URLs of all items in the folder
            let files = try fileManager.contentsOfDirectory(at: Constants.memgraphsFolder, includingPropertiesForKeys: nil, options: [])
            
            // Filter the files that end with ".memgraph"
            memgraphFiles = files.filter { $0.pathExtension == "memgraph" }
        } catch {
            print("Failed to read contents of directory: \(error.localizedDescription)")
        }
        
        return memgraphFiles
    }

    private func getNumberOfLeaks(from message: String) -> Int {
        if let regex = try? NSRegularExpression(pattern: regex, options: []) {
            // Find the first match in the input string
            if let match = regex.firstMatch(in: message, options: [], range: NSRange(message.startIndex..., in: message)) {
                // Extract the "d" value from the first capture group
                if let dRange = Range(match.range(at: 1), in: message), let dValue = Int(message[dRange]) {
                    return dValue
                }
            }
        }

        return 0
    }
}
