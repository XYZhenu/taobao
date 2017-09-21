//
//  TopShops.swift
//  taobao
//
//  Created by xyzhenu on 2017/9/19.
//  Copyright © 2017年 Xie Yan. All rights reserved.
//

import Foundation
import Ono
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
                if shopid != "" { shopIds.append(shopid) }
                if count == 0 { result( shopIds ) }
            })
        }
    }
    
    fileprivate func getShop(seller:String, result: @escaping ( String ) -> Void ) {
        let urlString = "https://store.taobao.com/shop/view_shop.htm?user_number_id=\(seller)".addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed) ?? ""
        let request = NSMutableURLRequest(url: URL(string: urlString)!)
        
        XYZHttp.instance().request(request, serializerType: XYSerializerType.origin, uploadProgress: nil, downloadProgress: nil, complete: { (_, res, error) in
            var outputs = ""
            let enc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))
            if let data = res as? Data, let str = String(data: data, encoding: String.Encoding(rawValue: enc) ) {
                let jsContext = JSContext()!
                do {
                    let document = try ONOXMLDocument(string: str, encoding: String.Encoding.utf8.rawValue)
                    document.rootElement.enumerateElements(withXPath: "//script", using: { (scriptElement, index, stop) in
                        if let scriptStr = scriptElement!.stringValue(), scriptStr.contains("g_page_config") {
                            stop?.pointee = ObjCBool(true)
                            jsContext.evaluateScript(scriptStr.replacingOccurrences(of: "window.", with: ""))
                            if let g_page_config = jsContext.objectForKeyedSubscript("shop_config"),
                                let dic = g_page_config.toDictionary(),
                                let shopId = dic["shopId"] as? String{
                                outputs = shopId
                            }
                        }
                    })
                } catch let error {
                    print(error)
                }
            }
            result(outputs)
        }, hudIn: nil)
    }
}
