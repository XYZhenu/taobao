//
//  GetHotItemsTests.swift
//  taobaoTests
//
//  Created by xyzhenu on 2017/9/21.
//  Copyright © 2017年 Xie Yan. All rights reserved.
//

import Foundation
import XCTest
@testable import taobao
class GetHotItemsTests: XCTestCase {
    //获取关键词
    func testGetKeyWords() {
        let expectResult = self.expectation(description: "expect result")
        
        let tops = TopKeywords()
        tops.getKeywords { (result) in
            XCTAssert(result.count >= 20, "should have 20+ value")
            expectResult.fulfill()
        }
        
        self.waitForExpectations(timeout: 5, handler: nil)
    }
    //获取店主
    func testGetTopSellers() {
        let keywords = ["椅子", "开关面板 罗格朗"]
        let expectResult = self.expectation(description: "expect result")
        let tops = TopSellers()
        tops.getTopSellers(keyWords: keywords) { (result) in
            expectResult.fulfill()
            XCTAssertTrue(result.count>0, "should have a lot of shop")
            print(result)
        }
        self.waitForExpectations(timeout: 50, handler: nil)
    }
    //获取店铺
    func testGetTopShops() {
        let sellers = ["2364751582","2364751582"]
        let expectResult = self.expectation(description: "expect result")
        let tops = TopShops()
        tops.getTopShops(sellers: sellers) { (result) in
            expectResult.fulfill()
            XCTAssertTrue(result.count == sellers.count, "should have a lot of shop")
            print(result)
        }
        self.waitForExpectations(timeout: 50, handler: nil)
    }
    //筛选店铺
    func testShopFilter() {
        let shops = ["115812794","115812794"]
        let expectResult = self.expectation(description: "expect result")
        let tops = ShopFilter()
        tops.filtShops(ids: shops) { (results) in
            expectResult.fulfill()
            XCTAssertTrue(results.count < shops.count, "should filter out a lot of shop")
            print(results)
        }
        self.waitForExpectations(timeout: 50, handler: nil)
    }
    
}
