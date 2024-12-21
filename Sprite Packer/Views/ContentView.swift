//
//  ContentView.swift
//  Sprite Packer
//
//  Created by James Randall on 18/12/2024.
//

import SwiftUI
import UniformTypeIdentifiers

enum Page {
    case source, svg, output
}

private let tabs = [
    TabPickerHeading(label: "SVG Settings", id: Page.svg),
    TabPickerHeading(label: "Output Settings", id: Page.output),
]

struct ContentView: View {
    @State private var svgSettings = SvgSettings()
    @State private var outputSettings = OutputSettings()
    @State private var droppedImage: [PackableImage] = []
    
    @State private var selectedPage : Page = .source
    @State private var isHoveringOnPack : Bool = false
    @State private var tabPickerHeight: CGFloat = 0 // State variable to store the height
    @State private var canPackAll : Bool = true

    private func packImages() {
        guard let binWidth = Int(outputSettings.widthText),let binHeight = Int(outputSettings.heightText) else { return }
        let binPacker = BinPacker(binWidth: binWidth, binHeight: binHeight)
        let packedImages = binPacker.pack(images: droppedImage)
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
        VStack {
            HStack {
                TabPicker(headings: tabs, selected: $selectedPage, reset: Page.source)
                Spacer()
                ToolbarButton(action: { packImages() }, text: "Pack")
                    .background(
                        self.isHoveringOnPack && !droppedImage.isEmpty
                        ? Color(red: 245.0/255.0, green: 145.0/255.0, blue: 22.0/255.0)
                        : Color(red: 186.0/255.0, green: 105.0/255.0, blue: 0.0/255.0)
                    )
                    .disabled(droppedImage.isEmpty)
                    .onHover(perform: { isHoveringOnPack = $0 })
            }
            //.background(Color(red: 43.0/255.0, green: 43.0/255.0, blue: 43.0/255.0))
            VStack(spacing: 0.0) {
                if !self.canPackAll {
                    VStack {
                        Text("Insufficient space in output image for all images to be packed. Try increasing the size in output settings.").foregroundStyle(.red)
                    }
                }
                ZStack {
                    if self.selectedPage == .output {
                        OutputSettingsView(settings: $outputSettings, canPackAll: $canPackAll, droppedImage: droppedImage)
                            .transition(.move(edge: .top))
                    }
                    else if self.selectedPage == .svg {
                        SvgSettingsView(settings: $svgSettings)
                    }
                }.clipped()
                DropAreaView(droppedImage: $droppedImage, svgSettings: $svgSettings, canPackAll: $canPackAll, outputSettings: outputSettings)
            }
            .animation(.easeInOut(duration: 0.3), value: selectedPage)
        }
        .background(TitlebarBackgroundView())
        .frame(minWidth: 640, minHeight: 480)
    }
}

#Preview {
    ContentView()
}
