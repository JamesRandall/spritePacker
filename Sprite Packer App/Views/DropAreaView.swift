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
private let icon = Image("trash-can")

struct PackableImageRow: View {
    let packableImage: PackableImage
    let onRemove : () -> Void
    @State private var isHovered = false
    
    var body: some View {
        GridRow {
            let image = NSImage(cgImage: packableImage.image, size: NSSize(width:packableImage.width, height: packableImage.height))
            if image.size.width > 160.0 || image.size.height > 100.0 {
                Image(nsImage: image).resizable().scaledToFit().frame(width: 160, height: 100)
            }
            else {
                Image(nsImage: image)
            }
            Text("\(Int(image.size.width)) x \(Int(image.size.height))")
            Text(packableImage.path).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            ToolbarButton(action: { self.onRemove() }, icon: icon)
                .background(Color(red: 203.0/255.0, green: 43.0/255.0, blue: 43.0/255.0))
                .opacity(isHovered ? 1.0 : 0.0)
                .cornerRadius(8.0)
        }
        .padding([.bottom, .top], 8.0)
        .onHover(perform: { isHover in isHovered = isHover })
    }
}

struct DropAreaView: View {
    @Binding var droppedImage: [PackableImage]
    @Binding var svgSettings: SvgSettings
    @Binding var canPackAll: Bool
    var outputSettings: OutputSettings
    @State private var isTargetted: Bool = false
    @State private var highlightedRow : String?
    
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
                                PackableImageRow(packableImage: packableImage, onRemove: { droppedImage.removeAll(where: { $0.path == packableImage.path } ) })
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
            let imagesToCheck = droppedImage
            let canPack = canPackImages(images: imagesToCheck, outputSettings: outputSettings)
            DispatchQueue.main.async {
                canPackAll = canPack;
            }
        }
    }
}
