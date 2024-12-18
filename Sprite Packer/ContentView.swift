//
//  ContentView.swift
//  Sprite Packer
//
//  Created by James Randall on 18/12/2024.
//

import SwiftUI
import UniformTypeIdentifiers

struct PackableImage {
    var image: NSImage
    var path: String
}

struct ContentView: View {
    @State private var widthText = "1024"
    @State private var heightText = "1024"
    @State private var droppedImage: [PackableImage] = []
    @State private var isTargetted: Bool = false
    
    private func loadDroppedImage(providers: [NSItemProvider]) {
        for provider in providers {
            if provider.canLoadObject(ofClass: URL.self) {
                let _ = provider.loadObject(ofClass: URL.self) { object, error in
                    if let fileURL = object {
                        // Ensure the URL points to a file (and not a remote URL)
                        guard fileURL.isFileURL else { return }
                        
                        // Load the image from the file URL
                        if let image = NSImage(contentsOf: fileURL) {
                            DispatchQueue.main.async {
                                // Append the image and path
                                self.droppedImage.append(PackableImage(image: image, path: fileURL.path))
                            }
                        } else {
                            print("Failed to create NSImage from file URL: \(fileURL.path)")
                        }
                    } else if let error = error {
                        print("Failed to load file URL: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    private func packImages() {
        let binWidth = Int(widthText)!
        let binHeight = Int(heightText)!
        let binPacker = BinPacker(binWidth: binWidth, binHeight: binHeight)
        let images = droppedImage.map(\.image)
        let packedImages = binPacker.pack(images: images)
        let combinedImage = ImageCombiner.combine(packedImages: packedImages, binWidth: binWidth, binHeight: binHeight)
        saveImage(image: combinedImage)
    }
    
    private func saveImage(image: NSImage) {
        let savePanel = NSSavePanel()
        savePanel.title = "Save Image"
        savePanel.allowedContentTypes = [UTType.png, UTType.jpeg, UTType.tiff] // Allowed file formats
        savePanel.nameFieldStringValue = "output" // Default file name

        savePanel.begin { response in
            if response == .OK, let url = savePanel.url {
                saveImageToFile(url: url, image: image)
            }
        }
    }
    
    private func saveImageToFile(url: URL, image: NSImage) {
        guard let tiffData = image.tiffRepresentation,
              let bitmapRep = NSBitmapImageRep(data: tiffData) else {
            print("Failed to create image representation.")
            return
        }

        let imageType: NSBitmapImageRep.FileType
        if url.pathExtension.lowercased() == "png" {
            imageType = .png
        } else if url.pathExtension.lowercased() == "jpeg" || url.pathExtension.lowercased() == "jpg" {
            imageType = .jpeg
        } else {
            imageType = .tiff
        }

        guard let imageData = bitmapRep.representation(using: imageType, properties: [:]) else {
            print("Failed to create image data.")
            return
        }

        do {
            try imageData.write(to: url)
            print("Image saved to \(url.path)")
        } catch {
            print("Failed to save image: \(error)")
        }
    }
    
    
    var body: some View {
        VStack(spacing: 16.0) {
            HStack {
                Text("Width")
                TextField("Output width", text: $widthText)
                Text("Height")
                TextField("Output height", text: $heightText)
                Button(action: {
                    packImages()
                }) {
                    Text("Pack")
                }
                .disabled(droppedImage.isEmpty)
            }
            ZStack {
                if (droppedImage.isEmpty) {
                    Text("Drop your images here").foregroundStyle(isTargetted ? Color.blue : Color.gray).animation(.easeInOut(duration: 0.3), value: isTargetted)
                }
                else {
                    ScrollView(.vertical) {
                        Grid {
                            ForEach(Array(droppedImage.enumerated()), id: \.offset) { offset,packableImage in
                                GridRow {
                                    let image = packableImage.image
                                    if image.size.width > 160.0 || image.size.height > 100.0 {
                                        Image(nsImage: image).resizable().scaledToFit().frame(width: 160, height: 100)
                                    }
                                    else {
                                        Image(nsImage: image)
                                    }
                                    Text("\(Int(image.size.width)) x \(Int(image.size.height))")
                                    Text(packableImage.path).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                                }
                                .padding([.bottom, .top], 8.0)
                                .id(offset)
                            }
                        }
                    }
                }
            }
            .frame(minWidth: 640, maxWidth: .infinity, minHeight: 640.0/(16.0/9.0), maxHeight: .infinity)
            .overlay {
                ZStack {
                    if (droppedImage.isEmpty || isTargetted) {
                        RoundedRectangle(cornerRadius: 20.0)
                            .stroke(style: StrokeStyle(lineWidth: 2, dash: [15, 10]))
                            .foregroundColor(isTargetted ? .blue : .gray)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: isTargetted)
            }
        }
        .padding()
        .onDrop(of: [UTType.fileURL], isTargeted: $isTargetted) { providers in
            loadDroppedImage(providers: providers)
            return true
        }
    }
}

#Preview {
    ContentView()
}
