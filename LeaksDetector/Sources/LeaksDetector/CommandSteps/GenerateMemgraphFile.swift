//
//  File.swift
//  
//
//  Created by Tuan Hoang on 6/1/24.
//

import Foundation

struct GenerateMemgraphFile: RunCommandStep {
    let executor: Executor
    let processName: String

    func run() throws {
        do {
            try executor.generateMemgraph(for: processName)
            log(message: "Generate memgraph successfully for process 🚀", color: .green)
        } catch let error {
            log(message: "❌ Can not find any process with name: \(processName)", color: .red)
            throw error
        }
    }
}
