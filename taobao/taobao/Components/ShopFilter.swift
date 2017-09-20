//
//  ShopFilter.swift
//  taobao
//
//  Created by Xie Yan, (Yan.Xie@partner.bmw.com) on 2017/9/20.
//  Copyright © 2017年 Xie Yan. All rights reserved.
//

import Foundation
protocol ShopFilterProtocol {
    func filtShops(ids:[String], result: ([String]) -> Void );
}
class ShopFilter: ShopFilterProtocol {
    func filtShops(ids: [String], result: ([String]) -> Void) {
        var validId = Set<String>(ids)
        var count = ids.count
        
        for id in ids {
            validShop(id: id, result: { (isValid) in
                count -= 1
                if !isValid { validId.remove(id) }
                if count == 0 { result(validId.map({ $0 })) }
            })
        }
    }
    fileprivate func validShop(id:String, result: ( Bool ) -> Void ) {
        
    }
}
