//: Playground - noun: a place where people can play

//import XYThirdParty
import Ono
import JavaScriptCore
let filepath = NSTemporaryDirectory().appending("topkeywords.txt")
let jsContext = JSContext()!

var str:String
do {
    str = try String(contentsOfFile: filepath)
} catch let error {
    let url = URL(string: "https://top.taobao.com/index.php?rank=focus&type=up")!
    let data = try Data(contentsOf: url)
    str =  String(data: data, encoding: String.Encoding.ascii)!
    do {
        try str.write(toFile: filepath, atomically: true, encoding: String.Encoding.utf8)
    } catch let error {
        print(error)
    }
}

var keywords = [String]()
do {
    let document = try ONOXMLDocument(string: str, encoding: String.Encoding.utf8.rawValue)
    for child in document.rootElement.children {
        let element = child as! ONOXMLElement
        print(element.tag)
    }
    document.rootElement.enumerateElements(withXPath: "//script", using: { (scriptElement, index, stop) in
        if var scriptStr = scriptElement!.stringValue(), scriptStr.contains("g_page_config") {
            stop?.pointee = ObjCBool(true)
            jsContext.evaluateScript(scriptStr)
            if let g_page_config = jsContext.objectForKeyedSubscript("g_page_config"),
                let dic = g_page_config.toDictionary(),
                let mods = dic["mods"] as? [String:Any],
                let wbang = mods["wbang"] as? [String:Any],
                let data = wbang["data"] as? [String:Any],
                let list = data["list"] as? [[String:Any]] {
                for item in list {
                    if let col2 = item["col2"] as? [String:String], let key = col2["text"]{
                        keywords.append(key)
                    }
                }
            }
        }
        
    })
    
} catch let error {
    
}

print(keywords)

