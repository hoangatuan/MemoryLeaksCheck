//
//  File.swift
//  
//
//  Created by Tuan Hoang on 6/1/24.
//

import ArgumentParser
import Foundation

struct MaestroCommand: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "maestro",
        abstract: "Perform memory leaks check by using Maestro testing tool."
    )

#if DEBUG
    private var processName = "MemoryLeaksCheck"
    private var maestroFlowPath: String = "/Users/hoanganhtuan/Desktop/MemoryLeaksCheck/maestro/leaksCheckFlow.yaml"
    private var dangerFilePath: String = "Dangerfile.leaksReport"
#else
    @Option(name: .shortAndLong, help: "The name of the running process")
    private var processName: String

    @Option(name: .long, help: "The path to the maestro ui testing yaml file")
    private var maestroFlowPath: String

    @Option(name: .long, help: "The path to the Dangerfile")
    private var dangerFilePath: String?
#endif

    public func run() throws {
        let executor = MaestroExecutor(flowPath: maestroFlowPath)
        let processor = Processor(
            configuration: .init(
                processName: processName,
                dangerFilePath: dangerFilePath
            ),
            executor: executor
        )
        
        processor.start()
    }
}
