//
//  File.swift
//  
//
//  Created by Tuan Hoang on 6/1/24.
//

import Foundation

struct Configuration {
    let processName: String
    let dangerFilePath: String?
}

struct Processor {
    let configuration: Configuration
    let executor: Executor
    let steps: [RunCommandStep]

    init(configuration: Configuration, executor: Executor) {
        self.configuration = configuration
        self.executor = executor
        var steps: [RunCommandStep] = [
            SimulateUIFlow(executor: executor),
            GenerateMemgraphFile(executor: executor, processName: configuration.processName),
            CheckLeaks(executor: executor)
        ]

        if let dangerFilePath = configuration.dangerFilePath {
            steps.append(DangerReportStep(dangerFilePath: dangerFilePath))
        }

        steps.append(CleanUp(executor: executor))

        self.steps = steps
    }

    private var processName: String {
        configuration.processName
    }

    func start() {
        do {
            try steps.forEach { step in
                try step.run()
            }
            log(message: "✅ The process finish successfully", color: .green)
        } catch {
            log(message: "❌ End the process with error", color: .red)
            Darwin.exit(EXIT_FAILURE)
        }
    }
}
