//
//  TopKeywordsTests.swift
//  taobao
//
//  Created by xyzhenu on 2017/9/18.
//  Copyright © 2017年 Xie Yan. All rights reserved.
//

import Foundation
import XCTest
@testable import taobao
class TopKeywordsTest: XCTestCase {
    func testGetKeyWords() {
        let expectResult = self.expectation(description: "expect result")
        
        let tops = TopKeywords()
        tops.getKeyWords { (result) in
            XCTAssertNotNil(result, "failed")
            XCTAssert(result!.count == 20, "should have 20 value")
            expectResult.fulfill()
        }
        
        self.waitForExpectations(timeout: 5, handler: nil)
    }
}
