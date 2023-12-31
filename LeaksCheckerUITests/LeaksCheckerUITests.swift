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
    
    /// This is a solution to generate memgraph using breakpoint.
    /// => this solution only work when you running test using Xcode.
    func testExample_usingBreakpointToGenrateMemgraph() throws {
        
        // UI tests must launch the application that they test.
        app = XCUIApplication(bundleIdentifier: "Hoang-Anh-Tuan.MemoryLeaksCheck")
        app.launch()
        
        app.staticTexts["Abandoned Memory Example"].tap()
        app.buttons["Scenarios"].tap()

        app.staticTexts["Leaks Memory Example"].tap()

        let simulateLogoutThenLoginActionButton = app.buttons["Simulate Logout then Login Action"]
        simulateLogoutThenLoginActionButton.tap()
        simulateLogoutThenLoginActionButton.tap()
        simulateLogoutThenLoginActionButton.tap()
        simulateLogoutThenLoginActionButton.tap()
        
        /// ⚠️⚠️⚠️ Currently, I use this breakpoint here to execute a shell script before the app quit. Please **do not remove this breakpoint** !!!
        /// ⚠️⚠️⚠️ Also this breakpoint will be shared via git, so please commit the breakpoint change to git as well.
        ///
        /// TODO: Currently, the shell script is hardcoded to the executable *leaksdetector* for the demo purpose. Need to find a way to pass in the script the correct path of *leaksdetector*
        /// - Parameters: The parameters is passed in the shell script is the program name, which is our app name. For this project, the app name is *MemoryLeaksCheck*.
        debugPrint("Start checking for leaks... 🔎")
    }
    
    /// This test will generate memgraph via command line. However, it only works on physical device, not simulator.
    /// For more info, please read README.
    func testExample() throws {
        let app = XCUIApplication()
        let options = XCTMeasureOptions()
        
        measure(
            metrics: [XCTMemoryMetric(application: app)],
            options: options
        ) {
            app.launch()
            startMeasuring()
            
            app.staticTexts["Abandoned Memory Example"].tap()
            app.buttons["Scenarios"].tap()

            app.staticTexts["Leaks Memory Example"].tap()

            let simulateLogoutThenLoginActionButton = app.buttons["Simulate Logout then Login Action"]
            simulateLogoutThenLoginActionButton.tap()
            simulateLogoutThenLoginActionButton.tap()
            simulateLogoutThenLoginActionButton.tap()
            simulateLogoutThenLoginActionButton.tap()
        }
    }
    
}
