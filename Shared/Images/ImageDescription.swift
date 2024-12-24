//
//  ImageDescription.swift
//  Sprite Packer
//
//  Created by James Randall on 21/12/2024.
//

import AppKit

func createDescription(packedImages: [PackedImage], combinedImage: CGImage) -> PackedImagesDescription {
    let width = CGFloat(combinedImage.width)
    let height = CGFloat(combinedImage.height)
    return PackedImagesDescription(
        width: Int(width),
        height: Int(height),
        images: packedImages.map { packedImage in
            PackedImageDescription(
                name: packedImage.name,
                path: packedImage.path,
                location: ImageLocation(
                    x: packedImage.frame.x,
                    y: packedImage.frame.y,
                    width: packedImage.frame.width,
                    height: packedImage.frame.height),
                textureCoordinates: TextureCoordinates(
                    u: CGFloat(packedImage.frame.x) / width,
                    v: CGFloat(packedImage.frame.y) / height,
                    u2: CGFloat(packedImage.frame.x + packedImage.frame.width) / width,
                    v2: CGFloat(packedImage.frame.y + packedImage.frame.height) / height
                ),
                svgFill: packedImage.svgFill
            )
        }
    )
}
