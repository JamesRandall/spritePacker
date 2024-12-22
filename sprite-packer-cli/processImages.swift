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
    
    let outputImageOption = options.output.imagePath ?? "packed.png"
    let outputImageUrl = outputImageOption.hasPrefix("/") ? URL(fileURLWithPath: outputImageOption) : URL(fileURLWithPath: sourceFolder).appendingPathComponent(outputImageOption.hasPrefix("./") ? String(outputImageOption.dropFirst(2)) : outputImageOption)
    
    let packableImages = findFiles(in: sourceFolder, matching: imageTypes)
        .filter({URL(fileURLWithPath: $0) != outputImageUrl})
        .compactMap({loadImage($0, svgSettings: svgSettings)})
        
    let binWidth = options.output.size.width
    let binHeight = options.output.size.height
    let binPacker = BinPacker(binWidth: binWidth, binHeight: binHeight)
    let packedImages = binPacker.pack(images: packableImages)
    let combinedImage = ImageCombiner.combine(packedImages: packedImages, binWidth: binWidth, binHeight: binHeight)
    let description = createDescription(packedImages: packedImages, combinedImage: combinedImage)
    
    saveImageToFile(url: outputImageUrl, image: combinedImage)
    saveDescription(description: description, sourceFolder: sourceFolder, outputPath: options.output.jsonPath ?? "packed.json")
    
    if packedImages.count == packedImages.count {
        print("All images packed successfully!")
    }
    else {
        print("Not all images could be packed ( \(packedImages.count) of \(packableImages.count) images were packed). Increase the size of the output image.")
    }
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
