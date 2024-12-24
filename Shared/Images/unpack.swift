//
//  unpack.swift
//  Sprite Packer
//
//  Created by James Randall on 24/12/2024.
//

import Foundation
import SwiftUI

func unpack(file: SpritePackerFile) -> [PackableImage] {
    let sourcePackedImage = FileManager.default.fileExists(atPath: file.imageUrl.path) ? file.imageUrl.loadCGImage() : nil
    guard let data = try? Data(contentsOf: file.jsonUrl) else { return [] }
    guard let description = try? JSONDecoder().decode(PackedImagesDescription.self, from: data) else { return [] }
    let result = description.images.compactMap({ packedImage in
        if packedImage.path.hasSuffix(".svg") {
            if FileManager.default.fileExists(atPath: packedImage.path) {
                let svgSettings = SvgSettings(
                    scaleToFit: true,
                    widthText: "\(packedImage.location.width)",
                    heightText: "\(packedImage.location.height)",
                    shouldFill: packedImage.svgFill != nil,
                    fill: Color(hex: packedImage.svgFill?.uppercased() ?? "#000000") ?? Color.black
                )
                
                if let image = convertSvgToImage(path: packedImage.path, svgSettings: svgSettings) {
                    return PackableImage(
                        image: image,
                        path: packedImage.path
                    )
                }
                else {
                    return nil
                }
            }
            
            return extractImage(source:sourcePackedImage, packedImage: packedImage)
        }
        else {
            if let image = NSImage(contentsOf: URL(fileURLWithPath: packedImage.path))?.cgImage(forProposedRect: nil, context: nil, hints: nil) {
                return PackableImage(
                    image: image,
                    path: packedImage.path
                )
            }
            return extractImage(source:sourcePackedImage, packedImage: packedImage)
        }
    })
    return result
}

private func extractImage(source: CGImage?, packedImage: PackedImageDescription) -> PackableImage? {
    guard let source = source else { return nil }
    
    let rect = CGRect(x: packedImage.location.x,
                      y: packedImage.location.y,
                      width: packedImage.location.width,
                      height: packedImage.location.height)
        
    // Create the cropped CGImage
    guard let croppedImage = source.cropping(to: rect) else {
        print("Failed to crop the image.")
        return nil
    }
    
    // Wrap the cropped image in a PackableImage and return
    return PackableImage(image: croppedImage, path: packedImage.path)
}
