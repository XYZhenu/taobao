//
//  ViewController.swift
//  taobao
//
//  Created by xyzhenu on 2017/9/25.
//  Copyright © 2017年 Xie Yan. All rights reserved.
//

import Foundation
class ViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    var log = ""
    func appendLog(msg:String) {
        log.append("\n"+msg)
        textView.text = log
    }
    @IBAction func start(_ sender: Any) {
        log = ""
        appendLog(msg: "start get keywords")
        TopKeywords().getKeywords { (result) in
            self.appendLog(msg: "result count keywords \(result.count)")
            self.perform(#selector(self.getTopSellers(keywords:)), with: result, afterDelay: 0)
        }
    }
    func getTopSellers(keywords:[String]) {
        appendLog(msg: "start get top sellers")
        TopSellers().getTopSellers(keyWords: keywords) { (sellers) in
            self.appendLog(msg: "result count sellers \(sellers.count)")
            self.perform(#selector(self.getTopShops(sellers:)), with: sellers, afterDelay: 0)
        }
    }
    func getTopShops(sellers:[String]) {
        appendLog(msg: "start get top shops")
        TopShops().getTopShops(sellers: sellers) { (shops) in
            self.appendLog(msg: "result count shops \(shops.count)")
//            self.perform(#selector(self.getFilteredShops(shops:)), with: shops, afterDelay: 0)
        }
    }
    func getFilteredShops(shops:[String]) {
        appendLog(msg: "start get filtered")
        ShopFilter().filtShops(ids: shops) { (filteredShops) in
            self.appendLog(msg: "result count filtered shops \(filteredShops.count)")
            self.appendLog(msg: filteredShops.description)
        }
    }
    @IBAction func pause(_ sender: Any) {
    }
    
}
