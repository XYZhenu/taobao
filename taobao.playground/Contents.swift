//: Playground - noun: a place where people can play

//import Ono
import JavaScriptCore
import Hpple
let urlString = "https://shop115812794.taobao.com/i/asynSearch.htm?mid=w-9705303928-0&wid=9705303928&path=/search.htm&search=y"
let filepath = NSTemporaryDirectory().appending("caches.txt")
let jsContext = JSContext()!

var str:String = ""
var htmlData = Data()

do {
    str = try String(contentsOfFile: filepath)
} catch let error {
    print(error)
    print("read cache error, get from network")
    let url = URL(string: urlString)!
    htmlData = try Data(contentsOf: url)
    let enc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))
    str =  String(data: htmlData, encoding: String.Encoding(rawValue: enc))!
    do {
        try str.write(toFile: filepath, atomically: true, encoding: String.Encoding.utf8)
    } catch let error {
        print(error)
        print("write cache error")
    }
}
let zhengz = "搜索到.{1,9}[0-9]*"
if let range = str.range(of: zhengz, options: .regularExpression, range: nil, locale: nil) {
    let numString = String(str[range])
    if let numRange = numString.range(of: "[0-9]+", options: .regularExpression, range: nil, locale: nil) {
        let numInt = String(numString[numRange])
        if let num = Int(numInt) {

        }
    }
}
