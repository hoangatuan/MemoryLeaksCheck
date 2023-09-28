
import Foundation
import ArgumentParser
import ShellOut

@main
struct LeaksDetector: ParsableCommand {
    
    @Argument(help: "The name of the running process")
    private var processName: String

    @Flag(name: .long, help: "Show extra logging for debugging purposes")
    private var verbose: Bool = false
    
    private var memgraphPath = "~/Desktop/Leaks.memgraph"
    private var regex: String = ".*(\\d+) leaks for (\\d+) total leaked bytes.*"
    
    func run() throws {
        debugPrint("Start looking for process with name: \(processName)... 🔎")
        
        if !generateMemgraph(for: processName) { return }
        
        do {
            try checkLeaks()
        } catch {
            debugPrint("Error occurs while checking for leaks ❌")
        }
    }
    
    private func generateMemgraph(for processName: String) -> Bool {
        do {
            try shellOut(to: "leaks \(processName) --outputGraph=\(memgraphPath)")
            debugPrint("Generate memgraph successfully for process 🚀")
            return true
        } catch {
            debugPrint("❌ Can not find any process with name: \(processName)")
            return false
        }
    }
    
    private func checkLeaks() throws {
        do {
            debugPrint("Start checking for leaks... ⚙️")
            try shellOut(to: "leaks", arguments: ["\(memgraphPath) -q"])
        } catch {
            let error = error as! ShellOutError
            if error.output.isEmpty { return }
            
            let inputs = error.output.components(separatedBy: "\n")
            guard let numberOfLeaksMessage = inputs.first(where: { $0.matches(regex) }) else { return }
            let numberOfLeaks = getNumberOfLeaks(from: numberOfLeaksMessage)

            if numberOfLeaks < 1 {
                debugPrint("Scan successfully. Don't find any leaks in the program! ✅")
                return
            }

            // Create a file to store the message, so that later Danger can read from that file
            // TODO: Convert to 1 message instead of using array-for loop to optimize execution time
            let fileName = "temporary.txt"
            for message in inputs {
                let updatedMessage = "\"\(message)\""
                try shellOut(to: "echo \(updatedMessage) >> \(fileName)")
            }

            // Cache memgraphfile if need

            debugPrint("Generating reports... ⚙️")
            try shellOut(to: "bundle exec danger --dangerfile=Dangerfile.leaksReport --danger_id=LeaksReport")
            
            debugPrint("Cleaning... 🧹")
            _ = try? shellOut(to: "rm \(memgraphPath)")
            _ = try? shellOut(to: "rm \(fileName)")
            
            debugPrint("Done ✅")
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
