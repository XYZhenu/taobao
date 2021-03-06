//
//  TopKeywords.swift
//  taobao
//
//  Created by Xie Yan, (Yan.Xie@partner.bmw.com) on 2017/9/15.
//  Copyright © 2017年 Xie Yan. All rights reserved.
//  let enc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))

import Hpple
import JavaScriptCore

protocol TopKeywordsProtocol {
    func getKeywords(result: @escaping ([String])->Void)
}
class TopKeywords: TopKeywordsProtocol {
    func getKeywords(result: @escaping ([String]) -> Void) {
        var set = Set<String>()
        var count = 0
        getUpKeyWords { (words) in
            if let WORDS = words { set = set.union(WORDS) }
            count += 1
            if (count == 2) { result(set.map({ $0 })) }
        }
        getHotKeyWords { (words) in
            if let WORDS = words { set = set.union(WORDS) }
            count += 1
            if (count == 2) { result(set.map({ $0 })) }
        }
    }
    fileprivate func getHotKeyWords(result: @escaping ([String]?) -> Void) {
        requestKeyWords(url: "https://top.taobao.com/index.php?rank=focus&type=hot", result: result)
    }
    fileprivate func getUpKeyWords(result: @escaping ([String]?) -> Void) {
        requestKeyWords(url: "https://top.taobao.com/index.php?rank=focus&type=up", result: result)
    }
    
    fileprivate func requestKeyWords(url:String, result: @escaping ([String]?)->Void) {
        let request = NSMutableURLRequest(url: URL(string: url)!)
        
        XYZHttp.instance().request(request, serializerType: XYSerializerType.origin, uploadProgress: nil, downloadProgress: nil, complete: { (_, res, error) in
            var returnStrings:[String]? = nil
            if let htmlData = res as? Data, let doc = TFHpple(htmlData: htmlData), let elements = doc.search(withXPathQuery: "//script") {
                let jsContext = JSContext()!
                for scriptElement in elements {
                    if let scriptStr = (scriptElement as! TFHppleElement).content, scriptStr.contains("g_page_config") {
                        jsContext.evaluateScript(scriptStr)
                        if let g_page_config = jsContext.objectForKeyedSubscript("g_page_config"),
                            let dic = g_page_config.toDictionary(),
                            let mods = dic["mods"] as? [String:Any],
                            let wbang = mods["wbang"] as? [String:Any],
                            let data = wbang["data"] as? [String:Any],
                            let list = data["list"] as? [[String:Any]] {
                            var keywords:[String] = []
                            for item in list {
                                if let col2 = item["col2"] as? [String:String], let key = col2["text"]{
                                    keywords.append(key)
                                }
                            }
                            returnStrings = keywords
                        }
                        break
                    }
                }
            }
            result(returnStrings)
        }, hudIn: nil)
    }
}
