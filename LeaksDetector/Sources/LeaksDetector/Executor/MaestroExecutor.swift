//
//  File.swift
//  
//
//  Created by Tuan Hoang Anh on 18/8/24.
//

import Foundation
import ShellOut

final class MaestroExecutor: DefaultExecutor {
    
    /// Maestro needs a flow.yaml to start simulating UI
    private let flowPath: String
    
    init(flowPath: String) {
        self.flowPath = flowPath
        super.init()
    }
    
    override func simulateUI() throws {
        try shellOut(to: "maestro test \(flowPath)")
    }
}
