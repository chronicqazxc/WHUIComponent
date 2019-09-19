//
//  WHUIComponentsTests.swift
//  WHUIComponentsTests
//
//  Created by Wayne Hsiao on 2019/9/19.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import XCTest
@testable import WHUIComponents

class WHUIComponentsTests: XCTestCase {
    
    let tableViewController = try! PaginateTableViewController.controller()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPaginateTableViewControllerNotThrowError() {
        XCTAssertNoThrow(PaginateTableViewControllerError.typeError)
    }
    
    func testPaginateTableViewControllerType() {
        XCTAssertTrue(tableViewController.isKind(of: PaginateTableViewController.self))
    }

}
