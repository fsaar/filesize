#!/usr/bin/env xcrun swift


import Cocoa
import Foundation

enum Result : Error {
    case invalidFormat
    case invalidPath
}

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

func parseCommandLine(arguments : [String]) -> (URL?,Int?,Option?) {
    guard arguments.count >= 4 else {
        return (nil,nil,.help)
    }
    guard let limitOption = Option(rawValue: arguments[2]), limitOption == .limit else {
        return (nil,nil,.help)
    }
    guard let limit = Int(arguments[3]) else {
        return (nil,nil,.help)
    }
    let path = arguments[1]
    let isRelativePath = path.hasPrefix(".") || path.hasPrefix("..")
    let relativePath = isRelativePath ? URL(fileURLWithPath: FileManager.default.currentDirectoryPath) : nil
    let url = URL(fileURLWithPath: path, relativeTo: relativePath)
    var isDirectory = ObjCBool(false)
    guard FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory),isDirectory.boolValue else {
        return (nil,nil,.help)
    }
    guard arguments.count > 4, let fileTypeOption = Option(rawValue: arguments[4]), Set<Option>([.swift,.objc]).contains(fileTypeOption) else {
        return (url,limit,nil)
    }
    return (url,limit,fileTypeOption)

}
FileManager.default.changeCurrentDirectoryPath("/Users/fsaar/Dropbox/Programs/filesize")
let (url,limit,option) = parseCommandLine(arguments: CommandLine.arguments)
guard option != .help, let limit = limit,let url = url else {
    print("""
filesize: Tool to list files that have more than <limit> number of lines
filesize <path> --limit <number> --<Options>
Options:
    --swift: consider only swift files
    --objc: consider only objc files
    --help: this help
""")
    exit(0)
}


let parser = DirectoryParser(with: url)
parser.parse(limit: limit, filetype: option?.directoryParserOption ?? .all)

