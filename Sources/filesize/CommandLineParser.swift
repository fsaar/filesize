//
//  CommandLineParser.swift
//  filesizePackageDescription
//
//  Created by Frank Saar on 21/12/2017.
//

import Foundation


class CommandLineParser {
    
    enum Result : Error {
        case invalidFormat
        case invalidPath
        case notEnoughArguments
        
        var localizedDescription: String? {
            switch self {
            case .notEnoughArguments:
                return "Invalid number of arguments"
            case .invalidPath:
                return "Invalid path"
            default:
                return nil
            }
        }
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
    
    let arguments : [String]
    init(arguments : [String]) {
        self.arguments = arguments
    }
    
    
    func parseCommandLine() throws -> (URL,Int,Option?) {
        guard arguments.count >= 4 else {
            throw Result.notEnoughArguments
        }
        guard let limitOption = Option(rawValue: arguments[2]), limitOption == .limit else {
            throw Result.invalidFormat
        }
        guard let limit = Int(arguments[3]) else {
            throw Result.invalidFormat
        }
        let path = arguments[1]
        let isRelativePath = path.hasPrefix(".") || path.hasPrefix("..")
        let relativePath = isRelativePath ? URL(fileURLWithPath: FileManager.default.currentDirectoryPath) : nil
        let url = URL(fileURLWithPath: path, relativeTo: relativePath)
        var isDirectory = ObjCBool(false)
        guard FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory),isDirectory.boolValue else {
            throw Result.invalidPath
        }
        guard arguments.count > 4, let fileTypeOption = Option(rawValue: arguments[4]), Set<Option>([.swift,.objc]).contains(fileTypeOption) else {
            return (url,limit,nil)
        }
        return (url,limit,fileTypeOption)
        
    }
}
