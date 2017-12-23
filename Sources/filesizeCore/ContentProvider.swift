//
//  URLEnumerator.swift
//  filesizePackageDescription
//
//  Created by Frank Saar on 22/12/2017.
//

import Foundation

public typealias ContentType = String
public typealias Content = String
public protocol ContentProvider {
    var contentList : [(ContentType,Content)] { get }
}


public struct FileContentGenerator : IteratorProtocol {
    let urls : [URL]
    var currentIndex = 0
    init?(with baseURL: URL) {
        guard let enumerator = FileManager.default.enumerator(at: baseURL, includingPropertiesForKeys: [URLResourceKey.isDirectoryKey], options: [.skipsPackageDescendants,.skipsHiddenFiles],errorHandler: { _,_ in return true }) else {
            return nil
        }
        urls =  enumerator.flatMap({ $0 as? URL })
    }
    
    public mutating func next() -> (path:String,content:String)? {
        guard currentIndex < urls.count else {
            return nil
        }
        let url = urls[currentIndex]
        let content = (try? String(contentsOf: url)) ?? ""
        let value = (url.path, content)
        currentIndex += 1
        return value
    }
}

public class FileContentProvider{
    let fileContentGenerator : FileContentGenerator
    public init?(with baseURL: URL) {
        guard let generator = FileContentGenerator(with: baseURL) else {
            return nil
        }
        fileContentGenerator = generator
    }
}

extension FileContentProvider : Sequence {
    public func makeIterator() -> FileContentGenerator {
        return fileContentGenerator
    }
}
