
import Foundation
import ArgumentParser
import ShellOut
import Darwin

@main
struct LeaksDetector: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "leaksdetector",
        abstract: "This program wraps up the logic integrate leaks checking with your CI workflow",
        subcommands: [
            MaestroCommand.self,
        ],
        defaultSubcommand: MaestroCommand.self
    )
}
