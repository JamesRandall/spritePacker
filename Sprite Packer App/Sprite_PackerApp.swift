//
//  Sprite_PackerApp.swift
//  Sprite Packer
//
//  Created by James Randall on 18/12/2024.
//

import SwiftUI

@main
struct Sprite_PackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
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
            CommandGroup(replacing: .newItem) {}
            CommandGroup(replacing: .toolbar) {}
            CommandGroup(replacing: .help) {}
        }
    }
    
    private func configureWindow(_ window: NSWindow) {
        //window.styleMask.insert(.fullSizeContentView)
        window.titlebarSeparatorStyle = .none
                // Make the titlebar transparent
                //window.titlebarAppearsTransparent = true
                
                // Optionally hide the title itself if you want a clean look
                //window.titleVisibility = .hidden
                
                // Allow dragging the window by clicking anywhere in the background
        window.isMovableByWindowBackground = true
    }
}


