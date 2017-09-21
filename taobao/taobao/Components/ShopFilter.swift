//
//  ShopFilter.swift
//  taobao
//
//  Created by Xie Yan, (Yan.Xie@partner.bmw.com) on 2017/9/20.
//  Copyright © 2017年 Xie Yan. All rights reserved.
//

import Foundation
import Ono
import JavaScriptCore
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
//        let request = NSMutableURLRequest(url: URL(string: urlString)!)
//
//        XYZHttp.instance().request(request, serializerType: XYSerializerType.origin, uploadProgress: nil, downloadProgress: nil, complete: { (_, res, error) in
//            var outputs = ""
//            if let data = res as? Data, let str = String(data: data, encoding: String.Encoding.utf8) {
//                let jsContext = JSContext()!
//
//                do {
//                    let document = try ONOXMLDocument(string: str, encoding: String.Encoding.utf8.rawValue)
//                    document.rootElement.enumerateElements(withXPath: "//script", using: { (scriptElement, index, stop) in
//                        if let scriptStr = scriptElement!.stringValue(), scriptStr.contains("g_page_config") {
//                            stop?.pointee = ObjCBool(true)
//                            jsContext.evaluateScript(scriptStr)
//                            if let g_page_config = jsContext.objectForKeyedSubscript("g_page_config"),
//                                let dic = g_page_config.toDictionary(),
//                                let mods = dic["mods"] as? [String:Any],
//                                let itemlist = mods["itemlist"] as? [String:Any],
//                                let data = itemlist["data"] as? [String:Any],
//                                let auctions = data["auctions"] as? [[String:Any]] {
//                                outputs.append(contentsOf: auctions.map({ (item)  in
//                                    var converted = [String:String]()
//                                    if let user_id = item["user_id"] as? String { converted["user_id"] = user_id }
//                                    if let nick = item["nick"] as? String { converted["nick"] = nick }
//                                    return converted
//                                }))
//                            }
//                        }
//                    })
//                } catch let error {
//                    print(error)
//                }
//            }
//            result(outputs)
//        }, hudIn: nil)
    }
}
