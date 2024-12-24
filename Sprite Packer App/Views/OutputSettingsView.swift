//
//  OutputSettingsView.swift
//  Sprite Packer
//
//  Created by James Randall on 21/12/2024.
//

import SwiftUI

struct OutputSettingsView : View {
    @Binding var settings : OutputSettings
    @Binding var canPackAll: Bool
    @AppStorage("selectedFolder") var selectedFolder: String = ""
    var droppedImage: [PackableImage]
    
    var body: some View {
        Form {
            HStack {
                TextField("Output folder", text: $settings.outputFolder)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .foregroundStyle(settings.outputFolderIsValid ? Color.primary : Color.red)
                    .onChange(of: settings.outputFolder) { settings.outputFolderIsValid = true }
                Spacer()
                Button(action: { selectFolder() }) { Image(systemName: "folder") }
            }
            ZStack {
                TextField("Output name", text: $settings.outputFileName).textFieldStyle(RoundedBorderTextFieldStyle())
                HStack {
                    Spacer()
                    Text("(.json, .png)")
                        .foregroundStyle(Color.gray)
                        .italic()
                        .offset(x:-6.0, y: -2.0)
                }
            }
            NumericTextField("Width", text: $settings.widthText)
            NumericTextField("Height", text: $settings.heightText)
            //Toggle("Pack into single file", isOn: $settings.packIntoSingleFile)
        }
        .padding([.top], 8.0)
        .padding([.leading, .trailing, .bottom])
        .onChange(of: settings.widthText) { checkFit() }
        .onChange(of: settings.heightText) { checkFit() }
        .onAppear() {
            if settings.outputFolder.isEmpty {
                if !selectedFolder.isEmpty {
                    settings.outputFolder = selectedFolder
                }
                if settings.outputFolder.isEmpty {
                    let homeDirectory = FileManager.default.homeDirectoryForCurrentUser.path
                    let parts = homeDirectory.split(separator: "/Library")
                    if let realHomeDirectory = parts.count > 1 ? parts[0] : nil {
                        settings.outputFolder = "\(realHomeDirectory)/Pictures"
                    }
                    else {
                        settings.outputFolder = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Pictures").path
                    }
                }
            }
        }
    }
    
    private func selectFolder() {
        let openPanel = NSOpenPanel()
        
        openPanel.canChooseFiles = false
        openPanel.canChooseDirectories = true
        openPanel.allowsMultipleSelection = false
        openPanel.prompt = "Select"
        openPanel.directoryURL = URL(fileURLWithPath: settings.outputFolder)

        if openPanel.runModal() == .OK, let url = openPanel.url {
            settings.outputFolder = url.path
            self.selectedFolder = url.path
        }
    }
    
    private func checkFit() {
        let imagesToCheck = droppedImage
        DispatchQueue.global().async {
            let (canPack,_) = canPackImages(images: imagesToCheck, outputSettings: settings)
            DispatchQueue.main.async {
                canPackAll = canPack;
            }
        }
    }
}
