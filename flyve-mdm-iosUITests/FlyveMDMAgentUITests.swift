//
//  flyve_mdm_iosUITests.swift
//  flyve-mdm-iosUITests
//
//  Created by Hector Rondon on 03/05/17.
//  Copyright © 2017 Teclib. All rights reserved.
//

import XCTest

class FlyveMDMAgentUITests: XCTestCase {

    /// This method is called before the invocation of each test method in the class.
    override func setUp() {
        super.setUp()
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launchEnvironment = [ "UITest": "1" ]
        setupSnapshot(XCUIApplication())
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    /// This method is called after the invocation of each test method in the class.
    override func tearDown() {
        super.tearDown()
    }

    func testExample() {
        snapshot("0Launch")
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
}
