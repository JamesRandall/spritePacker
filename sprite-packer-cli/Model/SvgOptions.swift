//
//  SvgOptions.swift
//  Sprite Packer
//
//  Created by James Randall on 21/12/2024.
//

struct SizeOptions : Codable {
    var width: Int
    var height: Int
}

struct SvgOptions : Codable {
    var scaleToFit : SizeOptions?
    var fill : String?
    
    static let defaultOptions : SvgOptions = .init()
}
