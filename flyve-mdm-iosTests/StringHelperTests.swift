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

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testBase64Encoded() {
        XCTAssertEqual("flyve".base64Encoded(), "Zmx5dmU=", "Base64 Encoded not valid")
    }
}
