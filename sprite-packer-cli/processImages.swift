//
//  processImages.swift
//  Sprite Packer
//
//  Created by James Randall on 21/12/2024.
//

import SwiftUI

private let imageTypes: [String] = ["png", "jpg", "jpeg", "svg"]

private extension String {
    func toColor() -> Color? {
        Color(hex: self)
    }
}

func processImages(sourceFolder: String, options: PackerOptions) {
    // a bit grim but I hadn't originally intended writing a cli version
    let svgSettings = SvgSettings()
    svgSettings.scaleToFit = options.svg.scaleToFit != nil
    svgSettings.widthText = "\(options.svg.scaleToFit?.width ?? 0)"
    svgSettings.heightText = "\(options.svg.scaleToFit?.height ?? 0)"
    svgSettings.shouldFill = options.svg.fill != nil
    svgSettings.fill = options.svg.fill?.toColor() ?? Color.black
    
    let packableImages = findFiles(in: sourceFolder, matching: imageTypes)
        .compactMap({loadImage($0, svgSettings: svgSettings)})
    let binWidth = options.output.size.width
    let binHeight = options.output.size.height
    let binPacker = BinPacker(binWidth: binWidth, binHeight: binHeight)
    let packedImages = binPacker.pack(images: packableImages)
    let combinedImage = ImageCombiner.combine(packedImages: packedImages, binWidth: binWidth, binHeight: binHeight)
    let description = createDescription(packedImages: packedImages, combinedImage: combinedImage)
    
    saveImage(image: combinedImage, sourceFolder: sourceFolder, outputPath: options.output.imagePath ?? "packed.png")
    saveDescription(description: description, sourceFolder: sourceFolder, outputPath: options.output.jsonPath ?? "packed.json")
}

private func saveImage(image: NSImage, sourceFolder: String, outputPath: String) {
    let outputUrl = outputPath.hasPrefix("/") ? URL(fileURLWithPath: outputPath) : URL(fileURLWithPath: sourceFolder).appendingPathComponent(outputPath)
    saveImageToFile(url: outputUrl, image: image)
}

private func saveDescription(description: PackedImagesDescription, sourceFolder: String, outputPath: String) {
    let outputUrl = outputPath.hasPrefix("/") ? URL(fileURLWithPath: outputPath) : URL(fileURLWithPath: sourceFolder).appendingPathComponent(outputPath)
    let jsonEncode = JSONEncoder()
    jsonEncode.outputFormatting = .prettyPrinted
    do {
        let data = try jsonEncode.encode(description)
        try data.write(to: outputUrl)
    } catch {
        print("Error saving description: \(error)")
    }
}
