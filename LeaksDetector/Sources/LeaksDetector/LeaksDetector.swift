
import ArgumentParser
import ShellOut

// https://www.fivestars.blog/articles/ultimate-guide-swift-executables/
// https://www.fivestars.blog/articles/a-look-into-argument-parser/

@main
struct LeaksDetector: ParsableCommand {
    
//    @Argument(help: "The name of the running process")
//    private var processName: String

//    @Option(name: .shortAndLong, help: "The week of the blog post as used in the file name")
//    private var week: Int?

    @Flag(name: .long, help: "Show extra logging for debugging purposes")
    private var verbose: Bool = false
    
    private var memgraphFileName = "LeaksDemo.memgraph"
    
    private var regexes: [String] = [
        ".*(\\d+) leaks for (\\d+) total leaked bytes.*",
        ".*MemoryLeaksCheck.*",
        ".*ROOT LEAK.*"
    ]
    
    func run() throws {
        do {
//            try shellOut(to: "leaks MemoryLeaksCheck --outputGraph=~/Desktop/LeaksDemo.memgraph")
//            print("Finish create memgraph")
            try shellOut(to: "leaks", arguments: ["~/Desktop/LeaksDemo.memgraph -q"])
        } catch {
            let error = error as! ShellOutError
            if error.output.isEmpty { return }

            let inputs = error.output.components(separatedBy: "\n")
            var res: [String] = []

            inputs.forEach {
                for regex in regexes {
                    if $0.matches(regex) {
                        res.append($0)
                        break
                    }
                }
            }
            
            // Create a file to store the message, so that later Danger can read from that file
            // TODO: Convert to 1 message instead of using array-for loop to optimize execution time
            if !res.isEmpty {
                let fileName = "temporary.txt"
                for message in res {
                    let updatedMessage = "\"\(message)\""
                    try shellOut(to: "echo \(updatedMessage) >> \(fileName)")
                }
            }
            
            // Cache memgraphfile if need
            
            // Execute Danger
            /// Split to multiple Danger instance: https://www.jessesquires.com/blog/2020/12/15/running-multiple-dangers/
            try shellOut(to: "bundle exec danger --dangerfile=Dangerfile.leaksReport --danger_id=LeaksReport")
            
            // Clean up
            // TODO: Remove memgraph & temporary.txt
        }
    }
    
}

extension String {
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}
