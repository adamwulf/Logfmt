import XCTest
@testable import Logfmt

final class LogfmtTests: XCTestCase {
    let str = "mumble"
    let bumble = MyClass()

    func testExample() throws {
        let result = String.logfmt(["foo": "2", "bar": str, "fumble": bumble])
        XCTAssertEqual("bar=mumble foo=2 fumble=\"myclass: yep!\"", result)
    }

    func testExample2() throws {
        let foo = Logfmt<MyCategory>(with: .info)
        foo.info(.foo, context: ["foo": "2", "bar": str, "fumble": bumble])
    }

    func testLogfmt() {
        let str1 = "asdf"
        XCTAssertEqual(String.logfmt(str1), "asdf")
        let str2 = "asdf\"asdf\""
        XCTAssertEqual(String.logfmt(str2), "\"asdf\\\"asdf\\\"\"")
        let num = 12
        XCTAssertEqual(String.logfmt(num), "12")
        let debugObj = Fumble()
        XCTAssertEqual(String.logfmt(debugObj), "debugStr")
        let descObj = Mumble()
        XCTAssertEqual(String.logfmt(descObj), "customString")
        let logfmtObj = Bumble()
        XCTAssertEqual(String.logfmt(logfmtObj), "grumblebumble")
        let arr1 = ["asdf", "qwer"]
        XCTAssertEqual(String.logfmt(arr1), "0=asdf 1=qwer")
        let arr2 = ["asdf", "qwer thjfdg"]
        XCTAssertEqual(String.logfmt(arr2), "0=asdf 1=\"qwer thjfdg\"")
        let dict1 = ["asdf": "qwer thjfdg"]
        XCTAssertEqual(String.logfmt(dict1), "asdf=\"qwer thjfdg\"")
        let dict2 = ["asdf": ["qwer thjfdg"]]
        XCTAssertEqual(String.logfmt(dict2), "asdf.0=\"qwer thjfdg\"")
        let dict3 = ["asdf": ["fumble": "qwer thjfdg"]]
        XCTAssertEqual(String.logfmt(dict3), "asdf.fumble=\"qwer thjfdg\"")
        let dict4 = ["asdf": ["fumble", "mumble"]]
        XCTAssertEqual(String.logfmt(dict4), "asdf.0=fumble asdf.1=mumble")
        let optional1: Grumble? = Grumble()
        let optional2: String? = nil
        let dict5: [String: [Any?]] = ["asdf": [optional1, optional2]]
        XCTAssertEqual(String.logfmt(dict5), "asdf.0=LogfmtTests.Grumble asdf.1=[none]")
        let optional3: String? = "grumble"
        let optional4: String? = nil
        let dict6: [String: [Any?]] = ["asdf": [optional3, optional4]]
        XCTAssertEqual(String.logfmt(dict6), "asdf.0=grumble asdf.1=[none]")

        let memoryContext = ["memory":
                                ["current": ["footprint": 128,
                                             "available": 2000 - 128,
                                             "limit": 2000],
                                 "peak": ["footprint": 348,
                                          "available": 2000 - 348,
                                          "limit": 2000]]]
        XCTAssertEqual(String.logfmt(memoryContext), ["memory.current.available=1872",
                                                      "memory.current.footprint=128",
                                                      "memory.current.limit=2000",
                                                      "memory.peak.available=1652",
                                                      "memory.peak.footprint=348",
                                                      "memory.peak.limit=2000"].joined(separator: " "))
    }

    func testLogfmt2() {
        let str1 = Humble()
        XCTAssertEqual(String.logfmt(str1), "customString.one=1 customString.two=two")
    }
}

enum MyCategory: String {
    case foo
}

class MyClass: CustomLogfmtStringConvertible {
    var loggingDescription: String {
        "myclass: yep!"
    }
}

class Bumble: CustomLogfmtStringConvertible {
    var loggingDescription: String {
        return "grumblebumble"
    }
}
class Fumble: CustomDebugStringConvertible {
    var debugDescription: String {
        return "debugStr"
    }
}
class Mumble: CustomStringConvertible {
    var description: String {
        return "customString"
    }
}
class Humble: CustomLogfmtDictionaryConvertible {
    var loggingDictionary: [String : any Loggable] {
        return ["customString": ["one": 1, "two": "two"]]
    }
}
class Grumble { }
