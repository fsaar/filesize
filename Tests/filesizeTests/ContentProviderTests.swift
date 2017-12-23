import Foundation
import XCTest

@testable import filesizeCore


private class MockContentProvider : Sequence{
    var currentIndex = 0
    let mockList : [(path:String,content:String)]
    init(mockList : [(path:String,content:String)]) {
        self.mockList = mockList
    }

    func makeIterator() -> AnyIterator<(path:String,content:String)> {
        return AnyIterator<(path:String,content:String)> {
            defer {
                 self.currentIndex += 1
            }
            guard self.currentIndex < self.mockList.count else {
                return nil
            }
            return  self.mockList[self.currentIndex]
        }
    }
}

class DirectoryParserTests : XCTestCase {
    func testReturnsCorrectNumberOfResults() throws {
        let provider = MockContentProvider(mockList:  [(".swift","1\n2\n"),(".swift","1\n2\n3\n")])
        let results = provider.parse(limit: 3, filetype: .swift)
        XCTAssert(results.count == 1)
    }
}
