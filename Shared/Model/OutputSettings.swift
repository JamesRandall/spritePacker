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
    var packIntoSingleFile : Bool = false
    var outputFolder : String = ""
    var outputFileName : String = "packed"
    var outputFolderIsValid = true
}
