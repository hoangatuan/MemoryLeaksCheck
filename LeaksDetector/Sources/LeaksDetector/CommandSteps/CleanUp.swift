//
//  File.swift
//  
//
//  Created by Tuan Hoang on 6/1/24.
//

import Foundation
import ShellOut

struct CleanUp: RunCommandStep {
    let executor: Executor

    func run() throws {
        log(message: "Cleaning... 🧹")
        _ = try? shellOut(to: "rm \(executor.getMemgraphPath())")
        _ = try? shellOut(to: "rm \(Constants.leaksReportFileName)")
    }
}
