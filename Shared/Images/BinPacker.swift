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
    let name: String
    let image: CGImage
    let frame: Rect
}

func canPackImages(images: [SourceImage], outputSettings: OutputSettings) -> Bool {
    guard let binWidth = Int(outputSettings.widthText),let binHeight = Int(outputSettings.heightText) else { return false }
    let binPacker = BinPacker(binWidth: binWidth, binHeight: binHeight)
    let packedImages = binPacker.pack(images: images)
    return packedImages.count == images.count
}

protocol SourceImage {
    var image: CGImage { get }
    var name: String { get }
    var width: Int { get }
    var height: Int { get }
}

// This is a pretty simple approach but does the job
class BinPacker {
    private var freeRectangles: [Rect]
    private let binWidth: Int
    private let binHeight: Int

    init(binWidth: Int, binHeight: Int) {
        self.binWidth = binWidth
        self.binHeight = binHeight
        self.freeRectangles = [Rect(x: 0, y: 0, width: binWidth, height: binHeight)]
    }

    func pack(images: [SourceImage]) -> [PackedImage] {
        let images = images.sorted { ($0.width * $0.height) > ($1.width * $1.height) }
        var packedImages: [PackedImage] = []

        for source in images {
            if let placement = findPlacement(for: Int(source.width), Int(source.height)) {
                packedImages.append(PackedImage(name: source.name, image: source.image, frame: placement))
                splitFreeRectangles(for: placement)
            } else {
                print("Image \(source.name) could not be packed.")
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
