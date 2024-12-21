//
//  NSImageExtensions.swift
//  Sprite Packer
//
//  Created by James Randall on 21/12/2024.
//

import AppKit

extension NSImage {
    /// Returns a new NSImage that is scaled (preserving aspect ratio)
    /// to fit within the specified targetSize.
    func scaledToFit(targetSize: NSSize) -> NSImage? {
        // Original size of the image
        let originalSize = self.size

        // If the image already fits, we can return a copy (or even self)
        if originalSize.width <= targetSize.width &&
            originalSize.height <= targetSize.height {
            return self.copy() as? NSImage
        }
        
        // Calculate the scale factor that preserves aspect ratio
        let widthRatio  = targetSize.width  / originalSize.width
        let heightRatio = targetSize.height / originalSize.height
        let scaleFactor = min(widthRatio, heightRatio)
        
        // Compute the new size using this scale factor
        let newSize = NSSize(
            width:  originalSize.width  * scaleFactor,
            height: originalSize.height * scaleFactor
        )
        
        // Create a new NSImage with the scaled size
        let newImage = NSImage(size: newSize)
        
        // Draw the original image into the new image, scaling as needed
        newImage.lockFocus()
        defer { newImage.unlockFocus() }
        
        self.draw(
            in: NSRect(origin: .zero, size: newSize),
            from: NSRect(origin: .zero, size: originalSize),
            operation: .copy,
            fraction: 1.0
        )
        
        return newImage
    }
    
    /// Returns a new NSImage of the exact targetSize. The original image is
    /// scaled to fit (preserving aspect ratio) and centered within the targetSize.
    ///
    /// - Parameter targetSize: The final width and height of the returned NSImage.
    /// - Returns: A new NSImage that is exactly `targetSize`, containing the scaled
    ///            and centered original image. If scaling or drawing fails, returns nil.
    func scaledToFitCentered(in targetSize: NSSize) -> NSImage? {
        let originalSize = self.size
        
        // If the original image is empty or the target size is zero, fail gracefully
        guard originalSize.width > 0, originalSize.height > 0,
              targetSize.width > 0, targetSize.height > 0 else {
            return nil
        }
        
        // Calculate aspect-fit scale factor
        let widthRatio  = targetSize.width  / originalSize.width
        let heightRatio = targetSize.height / originalSize.height
        let scaleFactor = min(widthRatio, heightRatio)
        
        // Determine the scaled image size
        let scaledWidth  = originalSize.width  * scaleFactor
        let scaledHeight = originalSize.height * scaleFactor
        
        // Center coordinates
        let xOffset = (targetSize.width  - scaledWidth)  / 2
        let yOffset = (targetSize.height - scaledHeight) / 2
        
        // Create a new NSImage with the exact target size
        let newImage = NSImage(size: targetSize)
        
        // Optional: Fill background with a color (e.g., white). Omit if you want transparency.
        /*
        newImage.lockFocus()
        NSColor.white.setFill()
        NSBezierPath(rect: NSRect(origin: .zero, size: targetSize)).fill()
        newImage.unlockFocus()
        */
        
        // Now draw the original, scaled image centered in the new image
        newImage.lockFocus()
        defer { newImage.unlockFocus() }
        
        self.draw(
            in: NSRect(x: xOffset, y: yOffset, width: scaledWidth, height: scaledHeight),
            from: NSRect(origin: .zero, size: originalSize),
            operation: .copy,
            fraction: 1.0
        )
        
        return newImage
    }
}
