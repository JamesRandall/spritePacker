//
//  OutputSettings.swift
//  Sprite Packer
//
//  Created by James Randall on 19/12/2024.
//

import SwiftUI

@Observable
class OutputSettings {
    var widthText : String = "1024"
    var heightText : String = "1024"
    var includeIntegerPositions : Bool = true
    var includeTextureCoordinatePositions : Bool = true
    var packIntoSingleFile : Bool = false
}

struct OutputSettingsView : View {
    @Binding var settings : OutputSettings
    
    var body: some View {
        Form {
            TextField("Width", text: $settings.widthText)
            TextField("Height", text: $settings.heightText)
            Toggle("Include integer image positions", isOn: $settings.includeIntegerPositions)
            Toggle("Include texture coordinate image positions", isOn: $settings.includeTextureCoordinatePositions)
            Toggle("Pack into single file", isOn: $settings.packIntoSingleFile)
        }
        //.background(TitlebarBackgroundView())
        .padding()
    }
}

