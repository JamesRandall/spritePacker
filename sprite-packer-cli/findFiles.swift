//
//  findFiles.swift
//  Sprite Packer
//
//  Created by James Randall on 21/12/2024.
//

import Foundation

func findFiles(in folderPath: String, matching pattern: String) -> [String] {
    let fileManager = FileManager.default
    let folderURL = URL(fileURLWithPath: folderPath)
    
    do {
        let fileURLs = try fileManager.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil)
        let matchingFiles = fileURLs.filter { $0.pathExtension == pattern.replacingOccurrences(of: "*.", with: "") }
        return matchingFiles.map { $0.path }
    } catch {
        print("Error while accessing folder: \(error)")
        return []
    }
}

func findFiles(in folderPath: String, matching patterns: [String]) -> [String] {
    patterns.flatMap({findFiles(in: folderPath, matching: $0)})
}
