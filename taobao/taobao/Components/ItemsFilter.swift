//
//  ItemsFilter.swift
//  taobao
//
//  Created by xyzhenu on 2017/9/25.
//  Copyright © 2017年 Xie Yan. All rights reserved.
//

import Foundation
protocol ItemsFilterProtocol {
    func getShopsItems(shops:[String], result: @escaping ([String]) -> Void)
}
class ItemsFilter: ItemsFilterProtocol {
    func getShopsItems(shops: [String], result: @escaping ([String]) -> Void) {
        
    }
    func getShopItem(shop:String, result: @escaping ([String]) -> Void) {
        
    }
    
}
