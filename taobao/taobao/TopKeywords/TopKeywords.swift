//
//  TopKeywords.swift
//  taobao
//
//  Created by Xie Yan, (Yan.Xie@partner.bmw.com) on 2017/9/15.
//  Copyright © 2017年 Xie Yan. All rights reserved.
//

import Foundation
protocol TopKeywordsProtocol {
    func getKeyWords(result:()->[String]?)
}
class TopKeywords: TopKeywordsProtocol {
    func getKeyWords(result: () -> [String]?) {
        XYNetwork.instance().request(<#T##request: NSMutableURLRequest##NSMutableURLRequest#>, serializerType: <#T##XYSerializerType#>, uploadProgress: <#T##((Progress) -> Void)?##((Progress) -> Void)?##(Progress) -> Void#>, downloadProgress: <#T##((Progress) -> Void)?##((Progress) -> Void)?##(Progress) -> Void#>, complete: <#T##((URLResponse, Any?, Error?) -> Void)?##((URLResponse, Any?, Error?) -> Void)?##(URLResponse, Any?, Error?) -> Void#>, hudIn: <#T##UIView?#>)
    }

    
}
