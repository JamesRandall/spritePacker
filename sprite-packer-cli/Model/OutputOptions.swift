//
//  OutputOptions.swift
//  Sprite Packer
//
//  Created by James Randall on 21/12/2024.
//

struct OutputOptions : Codable {
    var size : SizeOptions
    var packIntoSingleFile : Bool?
    var imagePath : String?
    var jsonPath : String?
    
    static let defaultOptions = OutputOptions(size: .init(width: 1024, height: 1024), packIntoSingleFile: nil)
}
