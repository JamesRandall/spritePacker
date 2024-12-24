//
//  SpritePackerFile.swift
//  Sprite Packer
//
//  Created by James Randall on 24/12/2024.
//

import Foundation

struct SpritePackerFile : Identifiable, Hashable, Codable {
    var imageUrl : URL
    var jsonUrl : URL
    
    var id : String { jsonUrl.path }
}
