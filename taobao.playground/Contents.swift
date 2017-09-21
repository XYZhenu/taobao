//: Playground - noun: a place where people can play

//import XYThirdParty
import Ono
import JavaScriptCore
let user_id = "2364751582"
let urlString = "https://store.taobao.com/shop/view_shop.htm?user_number_id=\(user_id)".addingPercentEncoding(withAllowedCharacters:
    .urlQueryAllowed) ?? ""
print(urlString)
let filepath = NSTemporaryDirectory().appending("caches.txt")
let jsContext = JSContext()!

var str:String
do {
    str = try String(contentsOfFile: filepath)
} catch let error {
    print(error)
    print("read cache error, get from network")
    let url = URL(string: urlString)!
    let data = try Data(contentsOf: url)
    let enc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))
str =  String(data: data, encoding: String.Encoding(rawValue: enc))!
    do {
        try str.write(toFile: filepath, atomically: true, encoding: String.Encoding.utf8)
    } catch let error {
        print(error)
        print("write cache error")
    }
}
var outputs = ""
do {
    let document = try ONOXMLDocument(string: str, encoding: String.Encoding.utf8.rawValue)
    document.rootElement.enumerateElements(withXPath: "//script", using: { (scriptElement, index, stop) in
        if let scriptStr = scriptElement!.stringValue(), scriptStr.contains("window.shop_config") {
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
print(outputs)
