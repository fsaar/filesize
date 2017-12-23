//
//  URLEnumerator.swift
//  filesizePackageDescription
//
//  Created by Frank Saar on 22/12/2017.
//

import Foundation

public class FileContentProvider : Sequence {
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
    let urls : [URL]
    var currentIndex = 0
    public init?(with baseURL: URL) {
        guard let enumerator = FileManager.default.enumerator(at: baseURL, includingPropertiesForKeys: [URLResourceKey.isDirectoryKey], options: [.skipsPackageDescendants,.skipsHiddenFiles],errorHandler: { _,_ in return true }) else {
            return nil
        }
        urls =  enumerator.flatMap({ $0 as? URL })
    }

    public func makeIterator() -> AnyIterator<(path:String,content:String)> {
        return AnyIterator<(path:String,content:String)> {
            guard self.currentIndex < self.urls.count else {
                return nil
            }
            let url = self.urls[self.currentIndex]
            let content = (try? String(contentsOf: url)) ?? ""
            let value = (url.path, content)
            self.currentIndex += 1
            return value
        }
    }
}

extension Sequence where Element == (path:String,content:String) {
    
    public func parse(limit : Int,filetype: FileContentProvider.FileType = .all) -> [(String,Int)] {
        let filteredValues = self.filter { filetype.filter(path: $0.path) }
        let values =  filteredValues.flatMap { tuple -> (String, Int) in
            let lineCount =  tuple.content.split(separator: "\n").count
            return (tuple.path,lineCount)
            }.filter {  return $1 >= limit }
        return values
    }
}
