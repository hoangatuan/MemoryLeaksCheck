//
//  File.swift
//  
//
//  Created by Tuan Hoang Anh on 18/8/24.
//

import Foundation

struct PrepareStep: RunCommandStep {
    
    func run() throws {
        try? FileManager.default.removeItem(at: Constants.memgraphsFolder)
        try FileManager.default.createDirectory(at: Constants.memgraphsFolder, withIntermediateDirectories: true)
    }
    
}
