//
//  File.swift
//  
//
//  Created by Tuan Hoang Anh on 18/8/24.
//

import Foundation
import ShellOut
import XCResultKit

final class XCUITestExecutor: Executor {
    
    private let xcResultPath = "./TestResults"
    
    enum ProjectType {
        case workspace(path: String)
        case project(path: String)
        
        var argument: String {
            switch self {
            case .workspace(let path):
                return "-workspace \(path)"
            case .project(let path):
                return "-project \(path)"
            }
        }
    }
    
    let projectType: ProjectType
    let scheme: String
    let destination: String
    
    init(
        project: String?,
        workspace: String?,
        scheme: String,
        destination: String
    ) throws {
        
        if let project = project {
            self.projectType = .project(path: project)
        } else if let workspace = workspace {
            self.projectType = .workspace(path: workspace)
        } else {
            throw NSError(domain: "XCUITestExecutor", code: 0, userInfo: ["message": "Either project or workspace must be provided"])
        }
        
        self.scheme = scheme
        self.destination = destination
    }
    
    func simulateUI() throws {
        try shellOut(
            to: "xcodebuild",
            arguments: [
                "test",
                projectType.argument,
                "-scheme",
                scheme,
                "-destination",
                destination,
                "-enablePerformanceTestsDiagnostics",
                "YES",
                "-derivedDataPath",
                "./derived_data",
                "-resultBundlePath",
                xcResultPath,
            ]
        )
    }
    
    /// XCUITest already generate memgraph by default, so in this step we just need to copy the memgraph file to the correct folder
    func generateMemgraph(for processName: String) throws {
        /// https://www.polpiella.dev/automatically-detect-memory-leaks-using-ui-tests/?utm_campaign=iOS%20CI%20Newsletter&utm_medium=email&utm_source=iOS%20CI%20Newsletter%20Issue%2048&utm_content=aug_11_24
        guard let url = URL(string: xcResultPath) else { return }
        let result = XCResultFile(url: url)
        guard let invocationRecord = result.getInvocationRecord() else { return }
        
        let testBundles = invocationRecord
            .actions
            .compactMap { action -> ActionTestPlanRunSummaries? in
                guard let id = action.actionResult.testsRef?.id, let summaries = result.getTestPlanRunSummaries(id: id) else {
                    return nil
                }
                
                return summaries
            }
            .flatMap(\.summaries)
            .flatMap(\.testableSummaries)
        
        let allTests = testBundles
            .flatMap(\.tests)
            .flatMap(\.subtestGroups)
            .flatMap(\.subtestGroups)
            .flatMap(\.subtests)
        
        let memoryGraphAttachments = allTests
            .compactMap { test -> ActionTestSummary? in
                guard let id = test.summaryRef?.id else { return nil }
                return result.getActionTestSummary(id: id)
            }
            .flatMap(\.activitySummaries)
            .filter { $0.title.contains("Added attachment named") && $0.title.contains(".memgraphset.zip") }
            .flatMap(\.attachments)
        
        for attachment in memoryGraphAttachments {
            let url = Constants.memgraphsFolder
            let filePath = url.appending(path: attachment.filename ?? "")
            result.exportAttachment(attachment: attachment, outputPath: url.path(percentEncoded: false))
            
            try shellOut(
                to: "tar",
                arguments: [
                    "-zxvf",
                    "\"\(filePath.path(percentEncoded: false))\"",
                    "-C",
                    url.path(percentEncoded: false)
                ]
            )
        }
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
        
        let postMemgraphs: [String] = memgraphFiles
            .map {
                let unzippedAndEscaped = ($0.path(percentEncoded: false) as NSString)
                    .replacingOccurrences(of: "(", with: "\\(")
                    .replacingOccurrences(of: ")", with: "\\)")
                    .replacingOccurrences(of: "[", with: "\\[")
                    .replacingOccurrences(of: "]", with: "\\]")
                
                return unzippedAndEscaped
            }
            .filter {
                $0.contains("post_")
            }
        
        return postMemgraphs
    }
}
