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

