//
//  SvgHandling.swift
//  Sprite Packer
//
//  Created by James Randall on 19/12/2024.
//

import AppKit
import SVGKit

func convertSvgToImage(path: String, svgSettings: SvgSettings) -> CGImage? {
    //let svgSource = SVGKSourceLocalFile()
    //svgSource.filePath = path
    guard let svgImage = SVGKImage(contentsOfFile: path) else {
        print("Could not load SVG file.")
        return nil
    }
    
    guard let rootElement = svgImage.domDocument.rootElement else {
        print("Could not access root element of the SVG.")
        return nil
    }
    
    //rootElement.setAttribute("svg:fill", value: "#ff0000")
    if svgSettings.shouldFill {
        let hexColor = svgSettings.fill.toHex()
        rootElement.setAttributeNS("http://www.w3.org/2000/svg", qualifiedName: "fill", value: hexColor)
    }
    
    guard let nsImage = svgImage.nsImage else {
        print("Could not create NSImage from SVGKImage.")
        return nil
    }
    
    if !svgSettings.scaleToFit {
        return nsImage.cgImage(forProposedRect: nil, context: nil, hints: nil)
    }
    
    if let intWidth = Int(svgSettings.widthText), let intHeight = Int(svgSettings.heightText) {
        let targetSize = CGSize(width: CGFloat(intWidth), height: CGFloat(intHeight))
        
        // Get CGImage from NSImage
        guard let cgImage = nsImage.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            print("Failed to retrieve CGImage from NSImage")
            return nil
        }

        // Create a bitmap context with the target size
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
        
        guard let context = CGContext(data: nil,
                                       width: Int(targetSize.width),
                                       height: Int(targetSize.height),
                                       bitsPerComponent: 8,
                                       bytesPerRow: Int(targetSize.width) * 4,
                                       space: colorSpace,
                                       bitmapInfo: bitmapInfo) else {
            print("Failed to create CGContext")
            return nil
        }
        
        // Clear the context
        context.setFillColor(CGColor(red: 0, green: 0, blue: 0, alpha: 0))
        context.fill(CGRect(origin: .zero, size: targetSize))
        
        // Calculate the aspect ratio and fit the image in the target size
        let imageAspect = CGFloat(cgImage.width) / CGFloat(cgImage.height)
        let targetAspect = targetSize.width / targetSize.height
        var drawRect: CGRect
        
        if imageAspect > targetAspect {
            // Image is wider than the target
            let scaledWidth = targetSize.width
            let scaledHeight = scaledWidth / imageAspect
            drawRect = CGRect(x: 0, y: (targetSize.height - scaledHeight) / 2,
                              width: scaledWidth, height: scaledHeight)
        } else {
            // Image is taller than or equal to the target
            let scaledHeight = targetSize.height
            let scaledWidth = scaledHeight * imageAspect
            drawRect = CGRect(x: (targetSize.width - scaledWidth) / 2, y: 0,
                              width: scaledWidth, height: scaledHeight)
        }
        
        // Draw the image centered in the context
        context.draw(cgImage, in: drawRect)
        
        // Return the resulting CGImage
        return context.makeImage()
    }
    return nil
}
