//
//  File.swift
//  
//
//  Created by Tuan Hoang on 6/1/24.
//

import Foundation
import ShellOut

struct DangerReportStep: RunCommandStep {
    let dangerFilePath: String

    func run() throws {
        do {
            try shellOut(to: "bundle exec danger --dangerfile=\(dangerFilePath) --danger_id=LeaksReport")
        } catch let error {
            log(message: "❌ Can not execute Danger", color: .red)
            throw error
        }
    }
}
