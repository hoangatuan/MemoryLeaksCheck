//
//  File.swift
//  
//
//  Created by Hoang Anh Tuan on 30/09/2023.
//

import Foundation
import ArgumentParser

enum ExecutorType: String, CaseIterable, Codable, ExpressibleByArgument {
    case maestro
//    case xcuitest
    
    static var supportedTypesDescription: String {
        "Current support types are: maestro"
    }
}

enum ParameterKeys {
    static let maestroFilePath: String = "maestroFlowPath"
}

typealias ExecutorParameters = [String: Any]
enum ExecutorFactory {
    static func createExecutor(
        for type: ExecutorType,
        parameters: ExecutorParameters = [:]
    ) -> Executor? {
        switch type {
            case .maestro:
                guard let flowPath = parameters[ParameterKeys.maestroFilePath] as? String else {
                    log(message: "❌ Used of type `maestro` will need to specify --maestro-flow-path", color: .red)
                    return nil
                }
                return MaestroExecutor(flowPath: flowPath)
        }
    }
}
