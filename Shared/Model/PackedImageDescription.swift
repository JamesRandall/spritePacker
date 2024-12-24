//
//  PackedImageDescription.swift
//  Sprite Packer
//
//  Created by James Randall on 21/12/2024.
//

struct ImageLocation : Codable {
    var x: Int
    var y: Int
    var width: Int
    var height: Int
}

struct TextureCoordinates : Codable {
    var u: Double
    var v: Double
    var u2: Double
    var v2: Double
}

struct PackedImageDescription : Codable {
    var name: String
    var path: String
    var location: ImageLocation
    var textureCoordinates: TextureCoordinates
    var svgFill : String?
}

struct PackedImagesDescription : Codable {
    var width: Int
    var height: Int
    
    var images : [PackedImageDescription]
}
