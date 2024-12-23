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
    var droppedImage: [PackableImage]
    
    var body: some View {
        Form {
            NumericTextField("Width", text: $settings.widthText)
            NumericTextField("Height", text: $settings.heightText)
            //Toggle("Pack into single file", isOn: $settings.packIntoSingleFile)
        }
        .padding([.top], 8.0)
        .padding([.leading, .trailing, .bottom])
        .onChange(of: settings.widthText) { checkFit() }
        .onChange(of: settings.heightText) { checkFit() }
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
