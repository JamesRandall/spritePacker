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
            CommandGroup(replacing: .toolbar) {}
            CommandGroup(replacing: .help) {}
        }
    }
    
    private func configureWindow(_ window: NSWindow) {
        window.titlebarSeparatorStyle = .none
        //window.titlebarAppearsTransparent = true
        //window.titleVisibility = .hidden
        window.isMovableByWindowBackground = true
    }
}
