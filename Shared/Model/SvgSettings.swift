//
//  SvgSettings.swift
//  Sprite Packer
//
//  Created by James Randall on 20/12/2024.
//

import SwiftUI

@Observable
class SvgSettings {
    var scaleToFit : Bool = false
    var widthText: String = "100"
    var heightText: String = "100"
    var shouldFill : Bool = false
    var fill : Color = Color.black
    
    init() {
        
    }
    
    init (scaleToFit: Bool, widthText: String, heightText: String, shouldFill: Bool, fill: Color) {
        self.scaleToFit = scaleToFit
        self.widthText = widthText
        self.heightText = heightText
        self.shouldFill = shouldFill
        self.fill = fill
    }
}

