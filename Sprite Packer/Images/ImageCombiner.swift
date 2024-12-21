//
//  ImageCombiner.swift
//  Sprite Packer
//
//  Created by James Randall on 18/12/2024.
//

import Cocoa

class ImageCombiner {
    static func combine(packedImages: [PackedImage], binWidth: Int, binHeight: Int) -> NSImage {
        let finalImage = NSImage(size: NSSize(width: binWidth, height: binHeight))
        
        finalImage.lockFocus()
        
        for packed in packedImages {
            let image = packed.image
            let frame = packed.frame
            
            let rect = NSRect(x: frame.x, y: frame.y, width: frame.width, height: frame.height)
            image.draw(in: rect)
        }
        
        finalImage.unlockFocus()
        
        return finalImage
    }
}
