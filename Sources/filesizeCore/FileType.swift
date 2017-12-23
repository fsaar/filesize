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


