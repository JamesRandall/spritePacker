//
//  GenerateIcon.swift
//  Sprite Packer Icon
//
//  Created by James Randall on 21/12/2024.
//

import SwiftUI

extension NSImage {
    func saveAsPNG(to url: URL) throws {
        guard let tiffData = self.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiffData) else {
            throw NSError(domain: "ImageError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to create image representation"])
        }
        
        if let pngData = bitmap.representation(using: .png, properties: [:]) {
            try pngData.write(to: url)
        } else {
            throw NSError(domain: "ImageError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to PNG"])
        }
    }
}

extension View {
    func snapshot() -> NSImage? {
        let hostingView = NSHostingView(rootView: self)

        let desiredSize = hostingView.fittingSize
        hostingView.setFrameSize(desiredSize)
        hostingView.layoutSubtreeIfNeeded()
        
        guard let bitmapRep = hostingView.bitmapImageRepForCachingDisplay(in: hostingView.bounds) else {
            return nil
        }
        
        hostingView.cacheDisplay(in: hostingView.bounds, to: bitmapRep)
        let nsImage = NSImage(size: desiredSize)
        nsImage.addRepresentation(bitmapRep)
        
        return nsImage
    }
}

func generateAppIcon(magnification: CGFloat, size: CGFloat, name: String, offset: Int = 0, limit: Int = 5, folder: URL?) -> some View {
    let appIconView = AppIconView(offset: offset, limit: limit, magnification: magnification / 2.0)
    guard let image = appIconView.snapshot() else { return appIconView }
    
    if let folder = folder {
        let saveURL = folder.appendingPathComponent(name)
        do {
            try image.saveAsPNG(to: saveURL)
            print("Saved icon to: \(saveURL)")
        } catch {
            print("Failed to save image: \(error)")
        }
    }
    
    return appIconView
}
