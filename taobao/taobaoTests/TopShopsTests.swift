//
//  TopShopsTests.swift
//  taobao
//
//  Created by xyzhenu on 2017/9/19.
//  Copyright © 2017年 Xie Yan. All rights reserved.
//

import Foundation
import XCTest
@testable import taobao
class TopShopsTest: XCTestCase {
    func testGetTopShops() {
//        let keywords1 = ["篷房", "连衣裙 背心裙", "双排扣复古羽绒服", "防晒衣女夏季韩版", "衬衫男", "毛毛口袋时尚羽绒服", "雪纺衫", "鱼竿", "双人床 板式床", "恒压一体阀", "电视", "电脑椅", "钓竿", "摩托车", "电脑桌", "移动硬盘", "秋冬斜跨女包", "板式床 双人床", "椅子", "开关面板 罗格朗"]
        let keywords = ["椅子", "开关面板 罗格朗"]
        let expectResult = self.expectation(description: "expect result")
        let tops = TopShops()
        tops.getTopShops(keyWords: keywords) { (result) in
            expectResult.fulfill()
            XCTAssertTrue(result.count>0, "should have a lot of shop")
            print(result)
        }
        self.waitForExpectations(timeout: 50, handler: nil)
    }
}
