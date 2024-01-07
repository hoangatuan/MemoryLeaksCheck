//
//  File.swift
//  
//
//  Created by Tuan Hoang on 6/1/24.
//

import ShellOut
import Foundation

struct SimulateUIFlow: RunCommandStep {
    let executor: Executor

    func run() throws {
        log(message: "Start running ui flow... 🎥")
        do {
            try executor.simulateUI()
        } catch let error {
            let error = error as! ShellOutError
            log(message: "❌ Something went wrong when trying to capture ui flow. \(error.message)", color: .red)
            throw error
        }
    }
}
