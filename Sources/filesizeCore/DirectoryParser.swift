//
//  DirectoryParser.swift
//  filesizePackageDescription
//
//  Created by Frank Saar on 18/12/2017.
//

import Foundation


public class DirectoryParser {
    public enum FileType {
        case swift
        case objc
        case all
        
        
        func filter(url : URL) -> URL? {
            switch self {
            case .swift:
                if isSwiftFile(url: url) {
                    return url
                }
            case .objc:
                if isObjcFile(url: url) {
                    return url
                }
            case .all:
                if isObjcFile(url: url) || isSwiftFile(url: url) {
                    return url
                }
            }
            return nil
        }
        
        private func isSwiftFile(url : URL) -> Bool {
            let isSwiftFile = url.pathExtension.lowercased() == "swift"
            return isSwiftFile
        }
        
        private func isObjcFile(url : URL) -> Bool {
            let isObjcFile = url.pathExtension.lowercased() == "m"
            return isObjcFile
            
        }
    }
    let enumerator : URLEnumerator
    
    public init(with enumerator : URLEnumerator) {
        self.enumerator = enumerator
    }
    
    public func parse(limit : Int,filetype: FileType = .all) -> [(URL,Int)] {
        let urls =  enumerator.enumerate().flatMap({ filetype.filter(url: $0) })
        let lineCounts = urls.map { ($0,(try? String(contentsOf: $0).split(separator: "\n").count) ?? 0)}
        let filteredCounts = lineCounts.filter { _,lineCount in
            return lineCount >= limit
            }
        return filteredCounts
    }
}

