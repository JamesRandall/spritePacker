//
//  DropAreaView.swift
//  Sprite Packer
//
//  Created by James Randall on 21/12/2024.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers
let contentBackgroundColor = Color(red: 12.0/255.0, green: 15.0/255.0, blue: 18.0/255.0)

struct DropAreaView: View {
    @Binding var droppedImage: [PackableImage]
    @Binding var svgSettings: SvgSettings
    @Binding var canPackAll: Bool
    var outputSettings: OutputSettings
    @State private var isTargetted: Bool = false
    @State private var highlightedRow : String?
    @State private var warningImagePaths : Set<String> = []
    
    var body: some View {
        VStack(spacing: 16.0) {
            ZStack {
                if (droppedImage.isEmpty) {
                    Text("Drop your images here").foregroundStyle(isTargetted ? Color.blue : Color.gray).animation(.easeInOut(duration: 0.3), value: isTargetted)
                }
                else {
                    ScrollView(.vertical) {
                        Grid {
                            ForEach(droppedImage, id: \.path) { packableImage in
                                PackableImageRow(
                                    packableImage: packableImage,
                                    isWarning: warningImagePaths.contains(packableImage.path),
                                    onRemove: {
                                        droppedImage.removeAll(where: { $0.path == packableImage.path } )
                                        checkImages()
                                    })
                            }
                        }
                        .padding()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay {
                ZStack {
                    if (droppedImage.isEmpty || isTargetted) {
                        RoundedRectangle(cornerRadius: 20.0)
                            .stroke(style: StrokeStyle(lineWidth: 2, dash: [15, 10]))
                            .foregroundColor(isTargetted ? .blue : .gray)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .padding()
                .animation(.easeInOut(duration: 0.3), value: isTargetted)
            }
            .background(contentBackgroundColor)
        }
        .onDrop(of: [UTType.fileURL], isTargeted: $isTargetted) { providers in
            loadDroppedImage(providers: providers)
            return true
        }
    }
    
    private func loadDroppedImage(providers: [NSItemProvider]) {
        
        let dispatchGroup = DispatchGroup()
        
        for provider in providers {
            if provider.canLoadObject(ofClass: URL.self) {
                dispatchGroup.enter()
                let _ = provider.loadObject(ofClass: URL.self) { object, error in
                    if let fileURL = object {
                        // Ensure the URL points to a file (and not a remote URL)
                        guard fileURL.isFileURL else { return }
                        
                        if fileURL.path.hasSuffix(".svg") {
                            if let image = convertSvgToImage(path: fileURL.path, svgSettings: svgSettings) {
                                DispatchQueue.main.async {
                                    let newImage = PackableImage(image: image, path: fileURL.path)
                                    if let index = self.droppedImage.firstIndex(of: newImage) {
                                        self.droppedImage[index] = newImage
                                    }
                                    else {
                                        self.droppedImage.append(newImage)
                                    }
                                    dispatchGroup.leave()
                                }
                            }
                            else {
                                print("Failed to load SVG file: \(fileURL.path)")
                                dispatchGroup.leave()
                            }
                        } else {
                            // Load the image from the file URL
                            if let image = NSImage(contentsOf: fileURL) {
                                print(image.size)
                                DispatchQueue.main.async {
                                    // Append the image and path
                                    let newImage = PackableImage(image: image.cgImage(forProposedRect: nil, context: nil, hints: nil)!, path: fileURL.path)
                                    if let index = self.droppedImage.firstIndex(of: newImage) {
                                        self.droppedImage[index] = newImage
                                    }
                                    else {
                                        self.droppedImage.append(newImage)
                                    }
                                    dispatchGroup.leave()
                                }
                            } else {
                                print("Failed to create NSImage from file URL: \(fileURL.path)")
                                dispatchGroup.leave()
                            }
                        }
                    } else if let error = error {
                        print("Failed to load file URL: \(error.localizedDescription)")
                        dispatchGroup.leave()
                    }
                }
            }
        }
        dispatchGroup.notify(queue: DispatchQueue.global()) {
            checkImages()
        }
    }
    
    private func checkImages() {
        let imagesToCheck = droppedImage
        let (canPack,missingImages) = canPackImages(images: imagesToCheck, outputSettings: outputSettings)
        DispatchQueue.main.async {
            canPackAll = canPack;
            warningImagePaths = Set(missingImages.map(\.path))
        }
    }
}
