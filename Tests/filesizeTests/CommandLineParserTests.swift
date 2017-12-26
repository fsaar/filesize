import Foundation
import XCTest
import filesizeCore


typealias CommandlineParserReturnValue = (URL?,Int?,CommandLineParser.Option?)
func ==(lhs : CommandlineParserReturnValue,rhs : CommandlineParserReturnValue) -> Bool {
    return lhs.0 == rhs.0 && lhs.1 == rhs.1 && lhs.2 == rhs.2
}

class CommandLineParserTests : XCTestCase {
    func testThatItCanBeInitialised() throws {
        let parser = CommandLineParser(arguments: [])
        XCTAssertNotNil(parser)
    }
    
    func testThatItShouldShowHelpIfHelpOptionGiven() {
        let parser = CommandLineParser(arguments: ["","--help"])
        let tuple = try! parser.parseCommandLine()
        let expectation : CommandlineParserReturnValue = (nil,nil,.help)
        XCTAssert(tuple == expectation)
    }
    
    func testThatItShouldShowHelpAndIgnoreOtherArgumentsIfGiven() {
        let parser = CommandLineParser(arguments: ["","--help","..","--limit","100"])
        let tuple = try! parser.parseCommandLine()
        let expectation : CommandlineParserReturnValue = (nil,nil,.help)
        XCTAssert(tuple == expectation)
    }
    
    func testThatItShouldShowInvalidArgumentsIf1ArgumentGiven() {
        let parser = CommandLineParser(arguments: [""])
        
        XCTAssertThrowsError(try parser.parseCommandLine()) { error in
            XCTAssertEqual(error as? CommandLineParser.Result, CommandLineParser.Result.notEnoughArguments)
        }
    }
    
    func testThatItShouldShowInvalidArgumentsIf2ArgumentsGiven() {
        let parser = CommandLineParser(arguments: ["",".."])
        
        XCTAssertThrowsError(try parser.parseCommandLine()) { error in
            XCTAssertEqual(error as? CommandLineParser.Result, CommandLineParser.Result.notEnoughArguments)
        }
    }
    
    func testThatItShouldShowInvalidArgumentsIf3ArgumentsGiven() {
        let parser = CommandLineParser(arguments: ["","..","--limit"])
        
        XCTAssertThrowsError(try parser.parseCommandLine()) { error in
            XCTAssertEqual(error as? CommandLineParser.Result, CommandLineParser.Result.notEnoughArguments)
        }
    }
    
    func testThatItShouldReturnPathAndLimitIfGiven() {
        let path = "/Users/fsaar/Dropbox/Programs/filesize"
        let parser = CommandLineParser(arguments: ["",path,"--limit","100"])
        let tuple = try! parser.parseCommandLine()
        let expectation : CommandlineParserReturnValue = (URL(fileURLWithPath: path),100,nil)
        XCTAssert(tuple == expectation)
        
    }
    
    func testThatItShouldThrowInvalidFormatIf2ndArgumentNotLimit() {
        let path = "/Users/fsaar/Dropbox/Programs/filesize"
        let parser = CommandLineParser(arguments: ["",path,"--somethingelse","100"])
        XCTAssertThrowsError(try parser.parseCommandLine()) { error in
            XCTAssertEqual(error as? CommandLineParser.Result, CommandLineParser.Result.invalidFormat)
        }
        
    }
    
    func testThatItShouldReturnTheCorrectFileRestrictionIfGivenSwift() {
        let path = "/Users/fsaar/Dropbox/Programs/filesize"
        let parser = CommandLineParser(arguments: ["",path,"--limit","100","--swift"])
        let tuple = try! parser.parseCommandLine()
        let expectation : CommandlineParserReturnValue = (URL(fileURLWithPath: path),100,.swift)
        XCTAssert(tuple == expectation)
        
    }
    
    func testThatItShouldReturnTheCorrectFileRestrictionIfGivenObjectiveC() {
        let path = "/Users/fsaar/Dropbox/Programs/filesize"
        let parser = CommandLineParser(arguments: ["",path,"--limit","100","--objc"])
        let tuple = try! parser.parseCommandLine()
        let expectation : CommandlineParserReturnValue = (URL(fileURLWithPath: path),100,.objc)
        XCTAssert(tuple == expectation)
        
    }
}
