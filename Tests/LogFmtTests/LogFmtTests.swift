import XCTest
@testable import LogFmt

final class LogFmtTests: XCTestCase {
    let str = "mumble"
    let bumble = MyClass()

    func testExample() throws {
        let result = String.logfmt(["foo": "2", "bar": str, "fumble": bumble])
        XCTAssertEqual("bar=mumble foo=2 fumble=\"myclass: yep!\"", result)
    }

    func testExample2() throws {
        let foo = LogFmt<MyCategory>(with: .info)
        foo.info(.foo, context: ["foo": "2", "bar": str, "fumble": bumble])
    }
}


enum MyCategory: String {
    case foo
}

class MyClass: CustomLogfmtStringConvertible {
    var logfmtDescription: String {
        "myclass: yep!"
    }
}
