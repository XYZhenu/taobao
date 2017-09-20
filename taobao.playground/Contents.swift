//: Playground - noun: a place where people can play

//import XYThirdParty
import Ono
import JavaScriptCore
let keywords = ["篷房", "连衣裙 背心裙", "双排扣复古羽绒服", "防晒衣女夏季韩版", "衬衫男", "毛毛口袋时尚羽绒服", "雪纺衫", "鱼竿", "双人床 板式床", "恒压一体阀", "电视", "电脑椅", "钓竿", "摩托车", "电脑桌", "移动硬盘", "秋冬斜跨女包", "板式床 双人床", "椅子", "开关面板 罗格朗"]
let key = "篷房"
let pagesize = 44 * 0
let urlString = "https://s.taobao.com/search?q=\(key)&fs=1&baoyou=1&auction_tag[]=4806&bcoffset=\(pagesize)".addingPercentEncoding(withAllowedCharacters:
    .urlQueryAllowed) ?? ""

print(urlString)
let filepath = NSTemporaryDirectory().appending("caches.txt")
let jsContext = JSContext()!

var str:String
do {
    str = try String(contentsOfFile: filepath)
} catch let error {
    let url = URL(string: urlString)!
    let data = try Data(contentsOf: url)
    str =  String(data: data, encoding: String.Encoding.utf8)!
    do {
        try str.write(toFile: filepath, atomically: true, encoding: String.Encoding.utf8)
    } catch let error {
        print(error)
        print("errot")
    }
}
var outputs = [[String:Any]]()
do {
    let document = try ONOXMLDocument(string: str, encoding: String.Encoding.utf8.rawValue)
    document.rootElement.enumerateElements(withXPath: "//script", using: { (scriptElement, index, stop) in
        if var scriptStr = scriptElement!.stringValue(), scriptStr.contains("g_page_config") {
            stop?.pointee = ObjCBool(true)
            jsContext.evaluateScript(scriptStr)
            if let g_page_config = jsContext.objectForKeyedSubscript("g_page_config"),
                let dic = g_page_config.toDictionary(),
                let mods = dic["mods"] as? [String:Any],
                let itemlist = mods["itemlist"] as? [String:Any],
                let data = itemlist["data"] as? [String:Any],
                let auctions = data["auctions"] as? [[String:Any]] {
                outputs.append(contentsOf: auctions.map({ (item)  in
//                    var converted = [String:String]()
//                    if let user_id = item["user_id"] as? String { converted["user_id"] = user_id }
//                    if let nick = item["nick"] as? String { converted["nick"] = nick }
                    return item
                }))
            }
        }
    })
} catch let error {
    
}
print(outputs.first!)
