//
//  File.swift
//  
//
//  Created by Tuan Hoang on 6/1/24.
//

import Foundation

enum Constants {
    static let leaksReportFileName = "leaksReport.txt"
    static var memgraphsFolder: URL {
        let currentDirectory = FileManager.default.currentDirectoryPath
        let memgraphsFolder = URL(fileURLWithPath: currentDirectory).appendingPathComponent("memgraphs")
        print("Memgraphs folder: \(memgraphsFolder.path)")
        return memgraphsFolder
    }
}
