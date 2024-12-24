//
//  Sprite_PackerApp.swift
//  Sprite Packer
//
//  Created by James Randall on 18/12/2024.
//

import SwiftUI
import UniformTypeIdentifiers

@main
struct Sprite_PackerApp: App {
    @Environment(\.openWindow) private var openWindow
    
    @SceneBuilder var body: some Scene {
        WindowGroup(id: "spritepacker", for: SpritePackerFile.self) { file in
            ContentView(file: file)
                .onAppear {
                    if let window = NSApplication.shared.windows.first {
                        DispatchQueue.main.async {
                            configureWindow(window)
                        }
                    }
                }
            
        }
        .commands {
            CommandGroup(replacing: .appSettings) {}
            CommandGroup(replacing: .toolbar) {}
            CommandGroup(replacing: .help) {}
            CommandGroup(after: .newItem) {
                Button("Open...") {
                    let panel = NSOpenPanel()
                    panel.allowedContentTypes = [UTType.json]
                        panel.allowsMultipleSelection = false
                        panel.canChooseDirectories = false
                        
                        if panel.runModal() == .OK, let url = panel.url {
                            openWindow(id: "spritepacker", value: SpritePackerFile(imageUrl: url, jsonUrl: url))
                        }
                }
                .keyboardShortcut("O", modifiers: [.command])
            }
        }
    }
    
    
    private func configureWindow(_ window: NSWindow) {
        window.titlebarSeparatorStyle = .none
        //window.titlebarAppearsTransparent = true
        //window.titleVisibility = .hidden
        window.isMovableByWindowBackground = true
    }
}
