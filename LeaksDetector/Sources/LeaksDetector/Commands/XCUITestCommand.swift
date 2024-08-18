//
//  File.swift
//  
//
//  Created by Tuan Hoang Anh on 18/8/24.
//

import ArgumentParser
import Foundation

struct XCUITestCommand: ParsableCommand {
    
    static let configuration = CommandConfiguration(
        commandName: "xcuitest",
        abstract: "Perform memory leaks check by using XCUITest"
    )

#if DEBUG
    private var project: String? = "/Users/tuanhoang/Documents/MemoryLeaksCheck/MemoryLeaksCheck.xcodeproj"
    private var workspace: String? = nil
    private var scheme: String = "MemoryLeaksCheck"
    private var destination: String = "'platform=iOS,name=Tuan iPhone'"
#else
    @Option(name: .shortAndLong, help: "build the project NAME")
    private var project: String?
    
    @Option(name: .shortAndLong, help: "build the workspace NAME")
    private var workspace: String

    @Option(name: .long, help: "build the scheme NAME")
    private var scheme: String

    @Option(name: .long, help: "use the destination described by DESTINATIONSPECIFIER (a comma-separated set of key=value pairs describing the destination to use. Please note that the destination must be real iOS device")
    private var destination: String
#endif
    
    public func run() throws {
        let executor = try XCUITestExecutor(
            project: project,
            workspace: workspace,
            scheme: scheme,
            destination: destination
        )
        
        let processor = Processor(
            configuration: .init(
                processName: "",
                dangerFilePath: nil
            ),
            executor: executor
        )
        
        processor.start()
    }
}
