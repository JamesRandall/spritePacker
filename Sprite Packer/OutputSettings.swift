//
//  OutputSettings.swift
//  Sprite Packer
//
//  Created by James Randall on 19/12/2024.
//

import SwiftUI

struct OutputSettings : View {
    @Binding var widthText : String
    @Binding var heightText : String
    
    var body: some View {
        HStack {
            Text("Width")
            TextField("Output width", text: $widthText)
            Text("Height")
            TextField("Output height", text: $heightText)
        }
        .background(TitlebarBackgroundView())
        .padding()
    }
}
