//
//  LeaksCheckerUITests.swift
//  LeaksCheckerUITests
//
//  Created by Hoang Anh Tuan on 26/09/2023.
//

import Foundation
import XCTest

final class LeaksCheckerUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func tearDownWithError() throws {
        app = nil
        super.tearDown()
    }
    
    /// This test will generate memgraph via command line. However, it only works on physical device, not simulator.
    /// For more info, please read README.
    func testMemoryLeaks1() throws {
        let app = XCUIApplication()
        let options = XCTMeasureOptions()
        options.iterationCount = 1
        
        measure(
            metrics: [XCTMemoryMetric(application: app)],
            options: options
        ) {
            app.launch()
            startMeasuring()

            app.staticTexts["Leaks Memory Example"].tap()

            let simulateLogoutThenLoginActionButton = app.buttons["Simulate Logout then Login Action"]
            simulateLogoutThenLoginActionButton.tap()
            simulateLogoutThenLoginActionButton.tap()
            simulateLogoutThenLoginActionButton.tap()
            simulateLogoutThenLoginActionButton.tap()
        }
    }
}
