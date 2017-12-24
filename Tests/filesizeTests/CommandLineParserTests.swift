import Foundation
import XCTest
import filesizeCore

class CommandLineParserTests : XCTestCase {
    func testThatItCanBeInitialised() throws {
        let parser = CommandLineParser(arguments: [])
        XCTAssertNotNil(parser)
    }
    
    
}
