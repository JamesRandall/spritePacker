//
//  PackableImage.swift
//  Sprite Packer
//
//  Created by James Randall on 21/12/2024.
//

import SwiftUI

struct PackableImage : Equatable, Hashable, SourceImage {
    var image: NSImage
    var path: String
    var name : String { URL(fileURLWithPath: path).deletingPathExtension().lastPathComponent }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(path)
    }
    
    static func == (lhs: PackableImage, rhs: PackableImage) -> Bool {
        lhs.path == rhs.path
    }
}
