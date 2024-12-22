//
//  saveImageToFile.swift
//  Sprite Packer
//
//  Created by James Randall on 21/12/2024.
//

import AppKit
import UniformTypeIdentifiers

func saveImageToFile(url: URL, image: CGImage) {
    guard let destination = CGImageDestinationCreateWithURL(url as CFURL, UTType.png.identifier as CFString, 1, nil) else {
        print("Failed to create image destination.")
        return
    }

    // Add the image to the destination
    CGImageDestinationAddImage(destination, image, nil)

    // Finalize the image destination
    if CGImageDestinationFinalize(destination) {
        print("Image saved successfully to \(url.path)")
    } else {
        print("Failed to save image.")
    }
}
