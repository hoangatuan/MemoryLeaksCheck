//
//  ProcessorTests.swift
//  
//
//  Created by Tuan Hoang on 6/1/24.
//

//import XCTest
//@testable import LeaksDetector
//
//final class ProcessorTests: XCTestCase {
//
//    func testGenerateStepsCorrectly() {
//        let sut = Processor(
//            configuration: .init(processName: "", dangerFilePath: "A"),
//            executor: MaestroExecutor(flowPath: "abc")
//        )
//
//        XCTAssertTypeEqual(sut.steps[0], PrepareStep.self)
//        XCTAssertTypeEqual(sut.steps[1], SimulateUIFlow.self)
//        XCTAssertTypeEqual(sut.steps[2], GenerateMemgraphFile.self)
//        XCTAssertTypeEqual(sut.steps[3], CheckLeaks.self)
//        XCTAssertTypeEqual(sut.steps[4], DangerReportStep.self)
//        XCTAssertTypeEqual(sut.steps[5], CleanUp.self)
//
//        XCTAssertEqual(sut.steps.count, 6)
//    }
//}
//
//public func XCTAssertTypeEqual(
//    _ lhs: Any?,
//    _ rhs: (some Any).Type,
//    file: StaticString = #filePath,
//    line: UInt = #line
//) {
//    guard let lhs else {
//        return XCTFail("First argument should not be nil", file: file, line: line)
//    }
//
//    if type(of: lhs) != rhs {
//        XCTFail("Expected \(rhs), got \(type(of: lhs))", file: file, line: line)
//    }
//}
