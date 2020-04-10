import XCTest
@testable import Index

final class IndexTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Index().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
