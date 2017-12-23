//
//  DirectoryParser.swift
//  filesizePackageDescription
//
//  Created by Frank Saar on 18/12/2017.
//

import Foundation
public enum FileType {
    case swift
    case objc
    case all
    
    
    func filter(path : String) -> Bool {
        switch self {
        case .swift:
            return isSwiftFile(path: path)
        case .objc:
            return isObjcFile(path: path)
            
        case .all:
            return self.isObjcFile(path: path) || self.isSwiftFile(path: path)
        }
    }
    
    private func isSwiftFile(path : String) -> Bool {
        let isSwiftFile = path.lowercased().hasSuffix(".swift")
        return isSwiftFile
    }
    
    private func isObjcFile(path : String) -> Bool {
        let isObjcFile = path.lowercased().hasSuffix(".m")
        return isObjcFile
        
    }
}
public class DirectoryParser<T : Sequence> where T.Element == (path:String,content:String) {
    
    let contentProvider : T
    
    public init(with sequence : T)   {
        self.contentProvider = sequence
    }
    
    public func parse(limit : Int,filetype: FileType = .all) -> [(String,Int)] {    
        let filteredValues = self.contentProvider.filter { filetype.filter(path: $0.path) }
        let values =  filteredValues.flatMap { tuple -> (String, Int) in
            let lineCount =  tuple.content.split(separator: "\n").count
            return (tuple.path,lineCount)
            }.filter {  return $1 >= limit }
        return values
    }
}

