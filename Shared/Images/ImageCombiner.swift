//
//  ImageCombiner.swift
//  Sprite Packer
//
//  Created by James Randall on 18/12/2024.
//

import Cocoa

class ImageCombiner {
    static func combine(packedImages: [PackedImage], binWidth: Int, binHeight: Int) -> CGImage? {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue

        guard let context = CGContext(data: nil,
                                       width: binWidth,
                                       height: binHeight,
                                       bitsPerComponent: 8,
                                       bytesPerRow: binWidth * 4,
                                       space: colorSpace,
                                       bitmapInfo: bitmapInfo) else {
            print("Failed to create CGContext")
            return nil
        }

        // Clear the context
        context.setFillColor(CGColor(red: 0, green: 0, blue: 0, alpha: 0))
        context.fill(CGRect(x: 0, y: 0, width: CGFloat(binWidth), height: CGFloat(binHeight)))

        // Draw each packed image into the context
        for packed in packedImages {
            let frame = packed.frame
            let rect = CGRect(x: frame.x, y: frame.y, width: frame.width, height: frame.height)
            context.draw(packed.image, in: rect)
        }

        // Create the final CGImage from the context
        return context.makeImage()
    }
}
