//
//  TopSellers.swift
//  taobao
//
//  Created by xyzhenu on 2017/9/21.
//  Copyright © 2017年 Xie Yan. All rights reserved.
//

import Foundation
import Ono
import JavaScriptCore
protocol TopSellersProtocol {
    func getTopSellers(keyWords: [String], result: @escaping ([String]) -> Void)
}
class TopSellers: TopSellersProtocol {
    
    func getTopSellers(keyWords: [String], result: @escaping ([String]) -> Void) {
        var sellerIDSet = Set<String>()
        var count = keyWords.count
        for key in keyWords {
            getTopSeller(keyWord: key, result: { (set) in
                count -= 1
                sellerIDSet = sellerIDSet.union(set)
                if count == 0 { result(sellerIDSet.map({ $0 })) }
            })
        }
    }
    fileprivate func getTopSeller(keyWord:String, result: @escaping (Set<String>) -> Void) {
        var count = 0
        var set = Set<String>()
        for index in 0..<5 {
            getTopSeller(keyWord: keyWord, page: index, result: { (items) in
                count += 1
                set = set.union(items.map({ $0["user_id"]! }))
                if count == 5 { result(set) }
            })
        }
    }
    fileprivate func getTopSeller(keyWord:String, page:Int, result: @escaping ([[String:String]]) -> Void) {
        let pagesize = 44 * page
        let urlString = "https://s.taobao.com/search?q=\(keyWord)&fs=1&baoyou=1&auction_tag[]=4806&bcoffset=0&p4ppushleft=%2C44&s=\(pagesize)".addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed) ?? ""
        print(urlString)
        let request = NSMutableURLRequest(url: URL(string: urlString)!)
        
        XYZHttp.instance().request(request, serializerType: XYSerializerType.origin, uploadProgress: nil, downloadProgress: nil, complete: { (_, res, error) in
            var outputs = [[String:String]]()
            if let data = res as? Data, let str = String(data: data, encoding: String.Encoding.utf8) {
                let jsContext = JSContext()!
                
                do {
                    let document = try ONOXMLDocument(string: str, encoding: String.Encoding.utf8.rawValue)
                    document.rootElement.enumerateElements(withXPath: "//script", using: { (scriptElement, index, stop) in
                        if let scriptStr = scriptElement!.stringValue(), scriptStr.contains("g_page_config") {
                            stop?.pointee = ObjCBool(true)
                            jsContext.evaluateScript(scriptStr)
                            if let g_page_config = jsContext.objectForKeyedSubscript("g_page_config"),
                                let dic = g_page_config.toDictionary(),
                                let mods = dic["mods"] as? [String:Any],
                                let itemlist = mods["itemlist"] as? [String:Any],
                                let data = itemlist["data"] as? [String:Any],
                                let auctions = data["auctions"] as? [[String:Any]] {
                                outputs.append(contentsOf: auctions.map({ (item)  in
                                    var converted = [String:String]()
                                    if let user_id = item["user_id"] as? String { converted["user_id"] = user_id }
                                    if let nick = item["nick"] as? String { converted["nick"] = nick }
                                    return converted
                                }))
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
