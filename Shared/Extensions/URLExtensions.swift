//
//  URLExtensions.swift
//  Sprite Packer
//
//  Created by James Randall on 24/12/2024.
//

import CoreGraphics
import Foundation
import ImageIO

extension URL {
    
    func loadCGImage() -> CGImage? {
        // Convert the file path to a URL
        // Create an image source from the file
        guard let imageSource = CGImageSourceCreateWithURL(self as CFURL, nil) else {
            print("Failed to create image source.")
            return nil
        }
        
        // Create the CGImage from the image source
        let cgImage = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
        
        return cgImage
    }
    
}
