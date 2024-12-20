//
//  SvgSettings.swift
//  Sprite Packer
//
//  Created by James Randall on 20/12/2024.
//

import SwiftUI

@Observable
class SvgSettings {
    var scaleToFit : Bool = true
    var widthText: String = "100"
    var heightText: String = "100"
    var shouldFill : Bool = true
    var fill : Color = Color.black
}

struct SvgSettingsView : View {
    @Binding var settings : SvgSettings
    
    var body : some View {
        Form {
            TextField("Width", text: $settings.widthText).disabled(!settings.scaleToFit)
            TextField("Height", text: $settings.heightText).disabled(!settings.scaleToFit)
            ColorPicker("Color", selection: $settings.fill).disabled(!settings.shouldFill)
            Toggle("Apply fill", isOn: $settings.shouldFill)
            Toggle("Scale to fit", isOn: $settings.scaleToFit)
        }.padding()
    }
}
