//
//  TopShops.swift
//  taobao
//
//  Created by xyzhenu on 2017/9/19.
//  Copyright © 2017年 Xie Yan. All rights reserved.
//

import Foundation
import JavaScriptCore
protocol TopShopsProtocol {
    func getTopShops(sellers: [String], result: @escaping ([String]) -> Void)
}
class TopShops: TopShopsProtocol {
    
    func getTopShops(sellers: [String], result: @escaping ([String]) -> Void) {
        var shopIds = [String]()
        var count = sellers.count
        
        for id in sellers {
            getShop(seller: id, result: { (shopid) in
                count -= 1
                if shopid != "" { shopIds.append(shopid) } else {
                    print(id)
                }
                if count == 0 { result( shopIds ) }
            })
        }
    }
    
    fileprivate func getShop(seller:String, result: @escaping ( String ) -> Void ) {
        let urlString = "https://store.taobao.com/shop/view_shop.htm?user_number_id=\(seller)"
        let request = NSMutableURLRequest(url: URL(string: urlString)!)
        
        XYZHttp.instance().request(request, serializerType: XYSerializerType.origin, uploadProgress: nil, downloadProgress: nil, complete: { (_, res, error) in
            var outputs = ""
            if let htmlData = res as? Data, let doc = TFHpple(htmlData: htmlData), let elements = doc.search(withXPathQuery: "//script") {
                let jsContext = JSContext()!
                for scriptElement in elements {
                    if let scriptStr = (scriptElement as! TFHppleElement).content, scriptStr.contains("shop_config") {
                        jsContext.evaluateScript(scriptStr.replacingOccurrences(of: "window.", with: ""))
                        if let g_page_config = jsContext.objectForKeyedSubscript("shop_config"),
                            let dic = g_page_config.toDictionary(),
                            let shopId = dic["shopId"] as? String{
                            outputs = shopId
                        }
                    }
                }
            }
            result(outputs)
        }, hudIn: nil)
    }
}
