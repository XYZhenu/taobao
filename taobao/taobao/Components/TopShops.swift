//
//  TopShops.swift
//  taobao
//
//  Created by xyzhenu on 2017/9/19.
//  Copyright © 2017年 Xie Yan. All rights reserved.
//

import Foundation
protocol TopShopsProtocol {
    func getTopShops(keyWords: [String], result: @escaping ([String]) -> Void)
}
class TopShops: TopShopsProtocol {
    
    func getTopShops(keyWords: [String], result: @escaping ([String]) -> Void) {
        
    }
    
    fileprivate func getTopShop(keyWord:String, result: @escaping (String) -> Void) {
        
    }
    
    
}
