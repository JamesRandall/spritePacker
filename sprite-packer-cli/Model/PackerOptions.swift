//
//  PackerOptions.swift
//  Sprite Packer
//
//  Created by James Randall on 21/12/2024.
//

struct PackerOptions : Codable {
    var output: OutputOptions
    var svg: SvgOptions
    
    static let defaultOptions = PackerOptions(
        output: .defaultOptions,
        svg: .defaultOptions
    )
}
