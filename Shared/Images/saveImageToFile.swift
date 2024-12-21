//
//  saveImageToFile.swift
//  Sprite Packer
//
//  Created by James Randall on 21/12/2024.
//

import AppKit

func saveImageToFile(url: URL, image: NSImage) {
    guard let tiffData = image.tiffRepresentation,
          let bitmapRep = NSBitmapImageRep(data: tiffData) else {
        print("Failed to create image representation.")
        return
    }
    
    let imageType: NSBitmapImageRep.FileType
    if url.pathExtension.lowercased() == "png" {
        imageType = .png
    } else if url.pathExtension.lowercased() == "jpeg" || url.pathExtension.lowercased() == "jpg" {
        imageType = .jpeg
    } else {
        imageType = .tiff
    }

    guard let imageData = bitmapRep.representation(using: imageType, properties: [:]) else {
        print("Failed to create image data.")
        return
    }

    do {
        try imageData.write(to: url)
    } catch {
        print("Failed to save image: \(error)")
    }
}
