//
//  ResourceTest.swift
//  WHUIComponentsTests
//
//  Created by Wayne Hsiao on 2019/9/20.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import XCTest
@testable import WHUIComponents

class ResourceTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBundleNotNil() {
        XCTAssertNotNil(Resource.bundle, "Resource bundle should not be nil.")
    }
    
    func testStoryboardNotNil() {
        XCTAssertNotNil(Resource.storyBoard, "StoryBoard should not be nil.")
    }

}
