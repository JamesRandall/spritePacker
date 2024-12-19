//
//  ImagePacker.swift
//  Sprite Packer
//
//  Created by James Randall on 18/12/2024.
//

// Some good ideas in here for other packing algorithms:
// https://www.david-colson.com/2020/03/10/exploring-rect-packing.html

import AppKit

struct Rect {
    var x: Int
    var y: Int
    var width: Int
    var height: Int
}

struct PackedImage {
    let image: NSImage
    let frame: Rect
}

class BinPacker {
    private var freeRectangles: [Rect]
    private let binWidth: Int
    private let binHeight: Int

    init(binWidth: Int, binHeight: Int) {
        self.binWidth = binWidth
        self.binHeight = binHeight
        self.freeRectangles = [Rect(x: 0, y: 0, width: binWidth, height: binHeight)]
    }

    func pack(images: [NSImage]) -> [PackedImage] {
        let images = images.sorted { ($0.size.width * $0.size.height) > ($1.size.width * $1.size.height) }
        var packedImages: [PackedImage] = []

        for image in images {
            if let placement = findPlacement(for: Int(image.size.width), Int(image.size.height)) {
                packedImages.append(PackedImage(image: image, frame: placement))
                splitFreeRectangles(for: placement)
            } else {
                print("Image \(image) could not be packed.")
            }
        }

        return packedImages
    }

    private func findPlacement(for width: Int, _ height: Int) -> Rect? {
        // Find the smallest free rectangle that can fit the image
        var bestFit: Rect? = nil
        var bestArea = Int.max

        for rect in freeRectangles {
            if width <= rect.width && height <= rect.height {
                let area = rect.width * rect.height
                if area < bestArea {
                    bestFit = rect
                    bestArea = area
                }
            }
        }

        guard let placement = bestFit else { return nil }

        // Return the placement rectangle
        return Rect(x: placement.x, y: placement.y, width: width, height: height)
    }

    private func splitFreeRectangles(for placement: Rect) {
        var newFreeRects: [Rect] = []

        for rect in freeRectangles {
            if isOverlapping(rect, placement) {
                // Split the free rectangle into up to 4 smaller rectangles
                if rect.x < placement.x { // Left
                    newFreeRects.append(Rect(x: rect.x, y: rect.y, width: placement.x - rect.x, height: rect.height))
                }
                if rect.y < placement.y { // Top
                    newFreeRects.append(Rect(x: rect.x, y: rect.y, width: rect.width, height: placement.y - rect.y))
                }
                if rect.x + rect.width > placement.x + placement.width { // Right
                    newFreeRects.append(Rect(x: placement.x + placement.width, y: rect.y, width: rect.x + rect.width - (placement.x + placement.width), height: rect.height))
                }
                if rect.y + rect.height > placement.y + placement.height { // Bottom
                    newFreeRects.append(Rect(x: rect.x, y: placement.y + placement.height, width: rect.width, height: rect.y + rect.height - (placement.y + placement.height)))
                }
            } else {
                newFreeRects.append(rect)
            }
        }

        freeRectangles = newFreeRects
    }

    private func isOverlapping(_ rect1: Rect, _ rect2: Rect) -> Bool {
        return !(rect1.x + rect1.width <= rect2.x || rect2.x + rect2.width <= rect1.x ||
                 rect1.y + rect1.height <= rect2.y || rect2.y + rect2.height <= rect1.y)
    }
}
