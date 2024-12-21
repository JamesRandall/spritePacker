//
//  TitlebarBackgroundView.swift
//  Sprite Packer
//
//  Created by James Randall on 19/12/2024.
//

import SwiftUI

struct TitlebarBackgroundView: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        // Choose a material and blending mode that matches the title bar appearance
        view.material = .titlebar
        view.blendingMode = .withinWindow
        view.state = .followsWindowActiveState
        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        // No updates needed
    }
}
