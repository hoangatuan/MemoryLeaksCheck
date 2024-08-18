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
        let fileManager = FileManager.default
        var memgraphFiles: [URL] = []
        
        // Create a directory enumerator to recursively go through the folder
        if let enumerator = fileManager.enumerator(at: Constants.memgraphsFolder, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles]) {
            // Iterate through the files and directories
            for case let fileURL as URL in enumerator {
                if fileURL.pathExtension == "memgraph" {
                    memgraphFiles.append(fileURL)
                }
            }
        }
        
        return memgraphFiles.map { $0.path() }
    }
}
