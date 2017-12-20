#!/usr/bin/env xcrun swift


import Cocoa
import Foundation

enum Option : String {
    case swift
    case objc
    case help
    case limit
    init?(rawValue : String) {
        guard rawValue.hasPrefix("--") else {
            return nil
        }
        let startIndex = rawValue.index(rawValue.startIndex,offsetBy:2)
        let optionString = rawValue[startIndex...].lowercased()
        switch optionString {
        case Option.swift.rawValue:
            self =  .swift
        case Option.objc.rawValue:
            self = .objc
        case Option.help.rawValue:
            self = .help
        case Option.limit.rawValue:
            self = .limit
        default:
            return nil
        }
    }
    
    var directoryParserOption : DirectoryParser.FileType? {
        switch self {
        case .swift:
            return .swift
        case .objc:
            return .objc
        default:
            return nil
        }
    }
}

func parseCommandLine(arguments : [String]) -> (Int?,Option?) {
    guard arguments.count >= 2 else {
        return (nil,.help)
    }
    guard let limitOption = Option(rawValue: arguments[1]), limitOption == .limit else {
        return (nil,.help)
    }
    guard let limit = Int(arguments[2]) else {
        return (nil,.help)
    }
    guard arguments.count > 2, let fileTypeOption = Option(rawValue: arguments[3]), Set<Option>([.swift,.objc]).contains(fileTypeOption) else {
        return (limit,nil)
    }
    return (limit,fileTypeOption)

}

let (limit,option) = parseCommandLine(arguments: CommandLine.arguments)
guard option != .help, let limit = limit else {
    print("""
filesize: Tool to list files that have more than <limit> number of lines
filezie --limit <number> --<Options>
Options:
    --swift: consider only swift files
    --objc: consider only objc files
    --help: this help
""")
    exit(0)
}


let parser = DirectoryParser(with: "/Users/fsaar/Dropbox/Programs/tflapp")
parser?.parse(limit: limit, filetype: option?.directoryParserOption ?? .all)

