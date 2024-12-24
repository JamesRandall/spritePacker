//
//  PreviewView.swift
//  Sprite Packer
//
//  Created by James Randall on 24/12/2024.
//

import SwiftUI

struct PreviewView : View {
    var image: Image?
    
    var body: some View {
        ZStack {
            image?.resizable().scaledToFit()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(contentBackgroundColor)
    }
}
