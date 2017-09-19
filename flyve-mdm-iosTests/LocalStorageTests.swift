//
//  LocalStorageTests.swift
//  flyve-mdm-ios
//
//  Created by Hector Rondon on 24/07/17.
//  Copyright © 2017 Teclib. All rights reserved.
//

import XCTest

@testable import flyve_mdm_ios

class LocalStorageTests: XCTestCase {

    /// This method is called before the invocation of each test method in the class.
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLocalStorage() {
        let valueTest = ["name": "MDM Agent"]
        setStorage(value: valueTest as AnyObject, key: "testName")
        
        if let value = getStorage(key: "testName") as? [String: String] {
            XCTAssertEqual(value["name"], "MDM Agent", "get and set Storage not valid")
        }
    }
}
