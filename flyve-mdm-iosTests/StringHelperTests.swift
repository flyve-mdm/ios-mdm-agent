//
//  StringHelperTests.swift
//  flyve-mdm-ios
//
//  Created by Hector Rondon on 24/07/17.
//  Copyright © 2017 Teclib. All rights reserved.
//

import XCTest

@testable import flyve_mdm_ios

class StringHelperTests: XCTestCase {

    /// This method is called before the invocation of each test method in the class.
    override func setUp() {
        super.setUp()
    }

    /// This method is called after the invocation of each test method in the class.
    override func tearDown() {
        super.tearDown()
    }

    /// Test if the base64 encoded string is valid
    func testBase64Encoded() {
        XCTAssertEqual("flyve".base64Encoded(), "Zmx5dmU=", "Base64 Encoded not valid")
    }
    
    /// Test if the base64 decode is valid
    func testBase64Decoded() {
        XCTAssertEqual("Zmx5dmU=".base64Decoded(), "flyve", "Base64 Decoded not valid")
    }
}
