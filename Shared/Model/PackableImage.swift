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
    var id : String { "\(path)_\(width)_\(height)" }
    var svgFill : String?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(path)
        hasher.combine(width)
        hasher.combine(height)
    }
    
    static func == (lhs: PackableImage, rhs: PackableImage) -> Bool {
        let result = lhs.path == rhs.path && lhs.width == rhs.width && lhs.height == rhs.height
        return result
    }
}
