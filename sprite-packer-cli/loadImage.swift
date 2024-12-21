//
//  loadImage.swift
//  Sprite Packer
//
//  Created by James Randall on 21/12/2024.
//

import AppKit

func loadImage(_ path: String, svgSettings: SvgSettings) -> PackableImage? {
    if path.hasSuffix(".svg") {
        guard let image = convertSvgToImage(path: path, svgSettings: svgSettings) else { return nil }
        let newImage = PackableImage(image: image, path: path)
        return newImage
    } else {
        guard let image = NSImage(contentsOfFile: path) else { return nil }
        return PackableImage(image: image, path: path)
    }
}
