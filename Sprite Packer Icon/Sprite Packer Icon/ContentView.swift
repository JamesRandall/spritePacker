//
//  ContentView.swift
//  Sprite Packer Icon
//
//  Created by James Randall on 21/12/2024.
//

import SwiftUI

struct ContentView: View {
    @State var folder : URL? = nil
    
    func selectFolder() {
        let openPanel = NSOpenPanel()
        openPanel.canChooseFiles = false
        openPanel.canChooseDirectories = true
        openPanel.allowsMultipleSelection = false
        openPanel.prompt = "Select Folder"
        
        if openPanel.runModal() == .OK {
            self.folder = openPanel.url
        }
    }
    
    var body: some View {
        VStack(spacing: 32.0) {
            HStack {
                Button("Save Images", action: { selectFolder() })
                Spacer()
            }
            ScrollView {
                HStack {
                    /*AppIconView(magnification: 1.0)
                     AppIconView(magnification: 512.0/1024.0)
                     AppIconView(magnification: 256.0/1024.0)
                     AppIconView(magnification: 128.0/1024.0)
                     AppIconView(magnification: 64.0/1024.0)
                     AppIconView(magnification: 32.0/1024.0)*/
                    generateAppIcon(magnification: 1.0, size: 1024, name: "AppIcon_1024.png", folder: folder)
                    generateAppIcon(magnification: 512.0 / 1024.0, size: 512, name: "AppIcon_512.png", folder: folder)
                    generateAppIcon(magnification: 256.0 / 1024.0, size: 256, name: "AppIcon_256.png", folder: folder)
                    generateAppIcon(magnification: 128.0 / 1024.0, size: 128, name: "AppIcon_128.png", folder: folder)
                    generateAppIcon(magnification: 64.0 / 1024.0, size: 64, name: "AppIcon_64.png", folder: folder)
                    generateAppIcon(magnification: 32.0 / 1024.0, size: 32, name: "AppIcon_32.png", folder: folder)
                }
            }
        }
        .padding(64.0)
    }
}

#Preview {
    ContentView()
}
