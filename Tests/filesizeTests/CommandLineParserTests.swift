import Foundation
import XCTest
import filesizeCore

class CommandLineParserTests : XCTestCase {
    func testCanBeInitialised() throws {
        let parser = CommandLineParser(arguments: [])
        XCTAssertNotNil(parser)
    }
}
