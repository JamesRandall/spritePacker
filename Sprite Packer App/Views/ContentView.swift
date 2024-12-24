//
//  ContentView.swift
//  Sprite Packer
//
//  Created by James Randall on 18/12/2024.
//

import SwiftUI
import UniformTypeIdentifiers

enum Page {
    case source, svg, output, preview
}

private let tabs = [
    TabPickerHeading(label: "Source", id: Page.source),
    TabPickerHeading(label: "Preview", id: Page.preview),
    TabPickerHeading(label: "Output Settings", id: Page.output),
    TabPickerHeading(label: "SVG Settings", id: Page.svg),
]

struct ContentView: View {
    @State private var svgSettings = SvgSettings()
    @State private var outputSettings = OutputSettings()
    @State private var droppedImage: [PackableImage] = []
    
    @State private var selectedPage : Page = .output
    @State private var isHoveringOnPack : Bool = false
    @State private var tabPickerHeight: CGFloat = 0 // State variable to store the height
    @State private var canPackAll : Bool = true
    @State private var previewImage: Image?
    @State private var isTargetted: Bool = false
    @State private var warningImagePaths : Set<String> = []
    @State private var currentPrimaryPage = Page.source
    
    @Binding var file : SpritePackerFile?

    
    
    var body: some View {
        VStack {
            HStack {
                TabPicker(headings: tabs, selected: $selectedPage, reset: currentPrimaryPage)
                    .onChange(of: selectedPage) { _,newValue in
                        if newValue == .preview || newValue == .source {
                            if newValue == .preview {
                                setupPreview()
                            }
                            self.currentPrimaryPage = newValue
                        }
                    }
                Spacer()
                ToolbarButton(action: { packImages() }, text: "Pack")
                    .background(
                        self.isHoveringOnPack && !droppedImage.isEmpty
                        ? Color(red: 245.0/255.0, green: 145.0/255.0, blue: 22.0/255.0)
                        : Color(red: 186.0/255.0, green: 105.0/255.0, blue: 0.0/255.0)
                    )
                    .disabled(droppedImage.isEmpty || !outputSettings.outputFolderIsValid)
                    .onHover(perform: { isHoveringOnPack = $0 })
            }
            //.background(Color(red: 43.0/255.0, green: 43.0/255.0, blue: 43.0/255.0))
            VStack(spacing: 0.0) {
                if !self.canPackAll {
                    VStack {
                        Text("Insufficient space in output image for all images to be packed. Increase the output size or remove the images with warnings.")
                            .foregroundStyle(.red)
                            .padding([.top,.bottom], 8.0)
                    }
                }
                ZStack {
                    if self.selectedPage == .output {
                        OutputSettingsView(settings: $outputSettings, canPackAll: $canPackAll, droppedImage: droppedImage)
                            .transition(.move(edge: .top))
                            .onChange(of: outputSettings.widthText) {
                                if self.currentPrimaryPage == .preview {
                                    setupPreview()
                                }
                            }
                            .onChange(of: outputSettings.heightText) {
                                if self.currentPrimaryPage == .preview {
                                    setupPreview()
                                }
                            }
                    }
                    else if self.selectedPage == .svg {
                        SvgSettingsView(settings: $svgSettings)
                    }
                }.clipped()
                if self.currentPrimaryPage == .preview {
                    PreviewView(image: previewImage)
                        .onDrop(of: [UTType.fileURL], isTargeted: $isTargetted) { providers in
                            loadDroppedImage(providers: providers)
                            return true
                        }
                } else {
                    DropAreaView(droppedImage: $droppedImage, svgSettings: $svgSettings, canPackAll: $canPackAll, isTargetted: $isTargetted, warningImagePaths: $warningImagePaths, outputSettings: outputSettings, checkImages: checkImages)
                        .onDrop(of: [UTType.fileURL], isTargeted: $isTargetted) { providers in
                            loadDroppedImage(providers: providers)
                            return true
                        }
                }
            }
            .animation(.easeInOut(duration: 0.3), value: selectedPage)
        }
        .background(TitlebarBackgroundView())
        //.frame(minWidth: 720, minHeight: 422) // size of a Mac App Store image of 1440x900
        .frame(minWidth: 2560.0/2.0, minHeight: 1600.0/2.0 - 28.0)
        .task {
            if let file = self.file {
                self.droppedImage = unpack(file: file)
                self.outputSettings.outputFolder = file.jsonUrl.deletingLastPathComponent().path
                self.outputSettings.outputFileName = file.jsonUrl.deletingPathExtension().lastPathComponent
            }
        }
    }
    
    private func packImages() {
        var isDirectory : ObjCBool = false
        let exists = FileManager.default.fileExists(atPath: outputSettings.outputFolder, isDirectory: &isDirectory)
        if !exists || !isDirectory.boolValue {
            selectedPage = .output
            outputSettings.outputFolderIsValid = false
            return
        }
        
        let baseUrl = URL(fileURLWithPath: outputSettings.outputFolder).appendingPathComponent(outputSettings.outputFileName).deletingPathExtension()
        let imageUrl = baseUrl.appendingPathExtension("png")
        let jsonUrl = baseUrl.appendingPathExtension("json")
        let shouldContinue = checkForFiles(imageUrl: imageUrl, jsonUrl: jsonUrl)
        if !shouldContinue { return }
        
        guard let binWidth = Int(outputSettings.widthText),let binHeight = Int(outputSettings.heightText) else { return }
        let binPacker = BinPacker(binWidth: binWidth, binHeight: binHeight)
        let packedImages = binPacker.pack(images: droppedImage)
        guard let combinedImage = ImageCombiner.combine(packedImages: packedImages, binWidth: binWidth, binHeight: binHeight) else { return }
        let description = createDescription(packedImages: packedImages, combinedImage: combinedImage)
        
        saveImageToFile(url: imageUrl, image: combinedImage)
        saveJson(jsonUrl: jsonUrl, description: description)
    }
    
    private func checkForFiles(imageUrl: URL, jsonUrl: URL) -> Bool {
        if FileManager.default.fileExists(atPath: imageUrl.path) || FileManager.default.fileExists(atPath: jsonUrl.path) {
            let alert = NSAlert()
            alert.messageText = "A file with the same name already exists."
            alert.informativeText = "Are you sure you want to overwrite the file?"
            alert.alertStyle = .warning
            
            // Add buttons
            alert.addButton(withTitle: "Continue")
            alert.addButton(withTitle: "Cancel")
            
            // Show alert modally
            let response = alert.runModal()
            return response == .alertFirstButtonReturn
        }
        return true
    }
    
    private func setupPreview() {
        guard let binWidth = Int(outputSettings.widthText),let binHeight = Int(outputSettings.heightText) else { return }
        let binPacker = BinPacker(binWidth: binWidth, binHeight: binHeight)
        let packedImages = binPacker.pack(images: droppedImage)
        guard let combinedImage = ImageCombiner.combine(packedImages: packedImages, binWidth: binWidth, binHeight: binHeight) else { return }
        previewImage = Image(nsImage: NSImage(cgImage: combinedImage, size: CGSize(width: binWidth, height: binHeight)))
    }
    
    private func saveJson(jsonUrl: URL, description: PackedImagesDescription) {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted]
            let jsonData = try encoder.encode(description)
            try jsonData.write(to: jsonUrl)
        }
        catch {
            print("Error writing JSON to file: \(error)")
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
                                    let newImage = PackableImage(
                                        image: image,
                                        path: fileURL.path,
                                        svgFill: svgSettings.shouldFill ? svgSettings.fill.toHex() : nil)
                                    if let index = self.droppedImage.firstIndex(where: { newImage.path == $0.path }) {
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
            if selectedPage == .preview {
                setupPreview()
            }
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
