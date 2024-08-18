//
//  File.swift
//  
//
//  Created by Hoang Anh Tuan on 30/09/2023.
//

import Foundation
import ShellOut
import ArgumentParser

protocol Executor {
    func simulateUI() throws
    func generateMemgraph(for processName: String) throws
    func memgraphPaths() -> [String]
}

class DefaultExecutor: Executor {
    init() { }
    
    func simulateUI() throws {
        fatalError("Need to override this func")
    }
    
    func generateMemgraph(for processName: String) throws {
        let memgraphPath = Constants.memgraphsFolder.path() + "/\(UUID().uuidString).memgraph"
        try shellOut(to: "leaks \(processName) --outputGraph=\(memgraphPath)")
    }
    
    func memgraphPaths() -> [String] {
        fatalError("Need to override this func")
    }
}
