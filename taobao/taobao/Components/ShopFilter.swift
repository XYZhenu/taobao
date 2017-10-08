//
//  ShopFilter.swift
//  taobao
//
//  Created by Xie Yan, (Yan.Xie@partner.bmw.com) on 2017/9/20.
//  Copyright © 2017年 Xie Yan. All rights reserved.
//

import Foundation
import JavaScriptCore
protocol ShopFilterProtocol {
    func filtShops(ids:[String], result: @escaping ([String]) -> Void );
}
class ShopFilter: ShopFilterProtocol {
    func filtShops(ids: [String], result: @escaping ([String]) -> Void) {
        convertShopItemsLinks(ids: ids) { (links) in
            DispatchQueue.main.async {
                var set = Set<String>(links)
                var linksCount = links.count
                
                for link in links {
                    self.validShop(shopLink: link, result: { (valid) in
                        linksCount -= 1
                        if !valid { set.remove(link) }
                        if linksCount == 0 { result(set.map({ $0 })) }
                    })
                }
            }
        }
    }
    fileprivate func convertShopItemsLinks(ids:[String], result: @escaping ( [String] ) -> Void ) {
        var validId = [String]()
        var count = ids.count
        
        for id in ids {
            getShopItemsLink(id: id, result: { (link) in
                count -= 1
                validId.append("https://shop\(id).taobao.com" + link)
                if count == 0 { result(validId.map({ $0 })) }
            })
        }
    }
    fileprivate func getShopItemsLink(id:String, result: @escaping ( String ) -> Void ) {
        let urlString = "https://shop\(id).taobao.com/search.htm?search=y"
        let request = NSMutableURLRequest(url: URL(string: urlString)!)

        XYZHttp.instance().request(request, serializerType: XYSerializerType.origin, uploadProgress: nil, downloadProgress: nil, complete: { (_, res, error) in
            var outputs = ""
            if let htmlData = res as? Data, let doc = TFHpple(htmlData: htmlData), let elements = doc.search(withXPathQuery: "//*[@id=\"J_ShopAsynSearchURL\"]") {
                for item in elements {
                    outputs = (item as! TFHppleElement).object(forKey: "value")
                }
            }
            result(outputs)
        }, hudIn: nil)
    }
    fileprivate func validShop(shopLink:String, result: @escaping (Bool) -> Void) {
        let request = NSMutableURLRequest(url: URL(string: shopLink)!)
        
        XYZHttp.instance().request(request, serializerType: XYSerializerType.origin, uploadProgress: nil, downloadProgress: nil, complete: { (_, res, error) in
            var outputs = false
            let enc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))
            let zhengz = "搜索到.{0,9}[0-9]*"
            if let htmlData = res as? Data,
                let str =  String(data: htmlData, encoding: String.Encoding(rawValue: enc)),
                let range = str.range(of: zhengz, options: .regularExpression, range: nil, locale: nil),
                let numString = String(str[range]),
                let numRange = numString.range(of: "[0-9]+", options: .regularExpression, range: nil, locale: nil),
                let numInt = String(numString[numRange]),
                let num = Int(numInt) {
                print("total \(num)")
                outputs = num > 4000
            }
            result(outputs)
        }, hudIn: nil)
    }
}
