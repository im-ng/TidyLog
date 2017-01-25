import XCTest
@testable import TidyLog

class TidyLogTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(TidyLog().text, "Hello, World!")
    }


    static var allTests : [(String, (TidyLogTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
