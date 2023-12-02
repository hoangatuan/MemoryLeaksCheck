
import Foundation
import ArgumentParser
import ShellOut
import Darwin

@main
struct LeaksDetector: ParsableCommand {
    
    static let configuration = CommandConfiguration(
        abstract: "This program wraps up the logic integrate leaks checking with your CI workflow"
    )
    
#if DEBUG
    private var processName = "MemoryLeaksCheck"
    private var executorType: ExecutorType = .maestro
    private var maestroFlowPath: String? = "/Users/hoanganhtuan/Desktop/MemoryLeaksCheck/maestro/leaksCheckFlow.yaml"
    private var dangerPath: String = "Dangerfile.leaksReport"
#else
    
    @Option(name: .long, help: "The name of the running process")
    private var processName: String

    @Option(name: .shortAndLong, help: "The testing tools you want to use. \(ExecutorType.supportedTypesDescription)")
    private var executorType: ExecutorType

    @Option(name: .long, help: "The path to the maestro ui testing yaml file")
    private var maestroFlowPath: String?

    @Option(name: .shortAndLong, help: "The path to the Dangerfile")
    private var dangerPath: String
#endif
    
    private var regex: String = ".*(\\d+) leaks for (\\d+) total leaked bytes.*"
    
    mutating func run() throws {
        guard let executor = ExecutorFactory.createExecutor(for: executorType, parameters: prepareParams()) else {
            Darwin.exit(EXIT_FAILURE)
        }
        
        log(message: "Start looking for process with name: \(processName)... 🔎")
        
        /// Step 1: Using UI Testing tool to simulate the flow
        if !simulateUIFlow(by: executor) {
            Darwin.exit(EXIT_FAILURE)
        }
        
        /// Step 2: Using *leak* tool provided by Apple to generate a memgrpah file
        if !generateMemgraph(by: executor) {
            Darwin.exit(EXIT_FAILURE)
        }
        
        do {
            /// Step 3: Using *leak* tool provided by Apple to process generated memgraph from Step2.
            try checkLeaks(by: executor)
        } catch {
            log(message: "❌ Error occurs while checking for leaks", color: .red)
            Darwin.exit(EXIT_FAILURE)
        }
    }
    
    private func simulateUIFlow(by executor: Executor) -> Bool {
        log(message: "Start running ui flow... 🎥")
        do {
            try executor.simulateUI()
            return true
        } catch {
            let error = error as! ShellOutError
            log(message: "❌ Something went wrong when trying to capture ui flow. \(error.message)", color: .red)
            return false
        }
    }
    
    private func generateMemgraph(by executor: Executor) -> Bool {
        do {
            try executor.generateMemgraph(for: processName)
            log(message: "Generate memgraph successfully for process 🚀", color: .green)
            return true
        } catch {
            log(message: "❌ Can not find any process with name: \(processName)", color: .red)
            return false
        }
    }
    
    private func checkLeaks(by executor: Executor) throws {
        do {
            log(message: "Start checking for leaks... ⚙️")
            let memgraphPath = executor.getMemgraphPath()
            
            /// Running this script always throw error (somehow the leak tool throw error here) => So we need to process the memgraph in the `catch` block.
            try shellOut(to: "leaks", arguments: ["\(memgraphPath) -q"])
        } catch {
            let error = error as! ShellOutError
            if error.output.isEmpty { return }
            
            let inputs = error.output.components(separatedBy: "\n")
            guard let numberOfLeaksMessage = inputs.first(where: { $0.matches(regex) }) else { return }
            let numberOfLeaks = getNumberOfLeaks(from: numberOfLeaksMessage)

            if numberOfLeaks < 1 {
                log(message: "Scan successfully. Don't find any leaks in the program! ✅", color: .green)
                return
            }

            // Create a file to store the message, so that later Danger can read from that file
            let fileName = "temporary.txt"
            for message in inputs {
                let updatedMessage = "\"\(message)\""
                try shellOut(to: "echo \(updatedMessage) >> \(fileName)")
            }
            
            // Send memgraph to remote storage if need

            log(message: "Founded leaks. Generating reports... ⚙️")
            
            do {
                try shellOut(to: "bundle exec danger --dangerfile=\(dangerPath) --danger_id=LeaksReport")
                log(message: "Done ✅", color: .green)
            } catch {
                log(message: "❌ Can not execute Danger", color: .red)
            }
            
            cleanup(executor: executor, fileName: fileName)
        }
    }
}

// MARK: - Helper functions
extension LeaksDetector {
    private func prepareParams() -> ExecutorParameters {
        var params: [String: String] = [:]
        params[ParameterKeys.maestroFilePath] = maestroFlowPath
        return params
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
    
    private func cleanup(executor: Executor, fileName: String) {
        log(message: "Cleaning... 🧹")
        _ = try? shellOut(to: "rm \(executor.getMemgraphPath())")
        _ = try? shellOut(to: "rm \(fileName)")
    }
}

extension String {
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}
