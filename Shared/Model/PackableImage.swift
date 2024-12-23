//
//  PackableImage.swift
//  Sprite Packer
//
//  Created by James Randall on 21/12/2024.
//

import Foundation
import CoreGraphics

struct PackableImage : Identifiable,Equatable, Hashable, SourceImage {
    var image: CGImage
    var path: String
    var name : String { URL(fileURLWithPath: path).deletingPathExtension().lastPathComponent }
    var width : Int { image.width }
    var height : Int { image.height }
    var id : String { path }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(path)
    }
    
    static func == (lhs: PackableImage, rhs: PackableImage) -> Bool {
        lhs.path == rhs.path
    }
}
