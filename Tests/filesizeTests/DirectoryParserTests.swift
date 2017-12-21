import Foundation
import XCTest

@testable import filesizeCore

class DirectoryParserTests : XCTestCase {
    func testCanBeInitialised() throws {
        let parser = DirectoryParser(with: URL(string:"www.emirates.com")!)
        XCTAssertNotNil(parser)
        
    }
}
