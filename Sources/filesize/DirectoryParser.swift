//
//  DirectoryParser.swift
//  filesizePackageDescription
//
//  Created by Frank Saar on 18/12/2017.
//

import Foundation


class DirectoryParser {
    enum FileType {
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
    let fileManager = FileManager.default
    let baseURL : URL
    
    
    init?(with path: String) {
        guard let url = URL(string:path) else {
            return nil
        }
        baseURL = url
    }
    
    func parse(limit : Int,filetype: FileType = .all) {
        let errorHandler = { (url : URL, error : Error) -> Bool in
            print("ERROR:\(url) : \(error)")
            return true
        }
        
        guard let enumerator = fileManager.enumerator(at: self.baseURL, includingPropertiesForKeys: [URLResourceKey.isDirectoryKey], options: [.skipsPackageDescendants,.skipsHiddenFiles],errorHandler:errorHandler) else {
            return
        }
        let urls =  enumerator.flatMap({ $0 as? URL }).flatMap({ filetype.filter(url: $0) })
        let lineCounts = urls.map { ($0,try? String(contentsOf: $0).split(separator: "\n").count)}
        let filteredCounts = lineCounts.filter { _,lineCount in
            return (lineCount ?? 0) >= limit
        }
        for (url,lineCount) in filteredCounts {
            print("\(url):\(lineCount!)")
        }
    }
}

private extension DirectoryParser {
    
}
