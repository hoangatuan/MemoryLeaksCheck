
import Foundation
import ArgumentParser
import ShellOut

// https://www.fivestars.blog/articles/ultimate-guide-swift-executables/
// https://www.fivestars.blog/articles/a-look-into-argument-parser/

@main
struct LeaksDetector: ParsableCommand {
    
    @Argument(help: "The name of the running process")
    private var processName: String

    @Flag(name: .long, help: "Show extra logging for debugging purposes")
    private var verbose: Bool = false
    
    private var memgraphFileName = "Leaks.memgraph"
    private var regex: String = ".*(\\d+) leaks for (\\d+) total leaked bytes.*"
    
    func run() throws {
        do {
            debugPrint("Process name: \(processName)")
            
            try shellOut(to: "leaks \(processName) --outputGraph=~/Desktop/\(memgraphFileName)")
            debugPrint("Generate memgraph successfully for process 🚀")
            
            try shellOut(to: "leaks", arguments: ["~/Desktop/\(memgraphFileName) -q"])
        } catch {
            let error = error as! ShellOutError
            if error.output.isEmpty { return }

            let inputs = error.output.components(separatedBy: "\n")
            guard let numberOfLeaksMessage = inputs.first(where: { $0.matches(regex) }) else { return }
            let numberOfLeaks = getNumberOfLeaks(from: numberOfLeaksMessage)
            
            if numberOfLeaks < 1 { return }
            
            // Create a file to store the message, so that later Danger can read from that file
            // TODO: Convert to 1 message instead of using array-for loop to optimize execution time
            
            let fileName = "temporary.txt"
            for message in inputs {
                let updatedMessage = "\"\(message)\""
                try shellOut(to: "echo \(updatedMessage) >> \(fileName)")
            }
            
            // Cache memgraphfile if need
            
            // Execute Danger
            /// Split to multiple Danger instance: https://www.jessesquires.com/blog/2020/12/15/running-multiple-dangers/
//            try shellOut(to: "bundle exec danger --dangerfile=Dangerfile.leaksReport --danger_id=LeaksReport")
            
            // Clean up
            // TODO: Remove memgraph & temporary.txt
        }
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

extension String {
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}
