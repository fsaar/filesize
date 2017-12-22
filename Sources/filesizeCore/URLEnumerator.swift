//
//  URLEnumerator.swift
//  filesizePackageDescription
//
//  Created by Frank Saar on 22/12/2017.
//

import Foundation

public protocol URLEnumerator {
    func enumerate() -> [URL]
}

public class FileEnumerator : URLEnumerator {
    let baseURL : URL
    lazy var filemanager = FileManager.default
    public init (with url: URL) {
        baseURL = url
    }
    
    public func enumerate() -> [URL] {
        guard let enumerator = self.filemanager.enumerator(at: self.baseURL, includingPropertiesForKeys: [URLResourceKey.isDirectoryKey], options: [.skipsPackageDescendants,.skipsHiddenFiles],errorHandler: { _,_ in return true }) else {
            return []
        }
        let urls =  enumerator.flatMap({ $0 as? URL })
        return urls
    }
    
}
