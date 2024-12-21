//
//  ColorExtensions.swift
//  Sprite Packer
//
//  Created by James Randall on 21/12/2024.
//

import SwiftUI

extension Color {
    /// Returns a hex string (e.g. "#FF0000" for red) if the color can be
    /// converted to an RGB or monochrome color space. If `includeAlpha` is true,
    /// it uses the format "#RRGGBBAA".
    func toHex(includeAlpha: Bool = false) -> String? {
        // Attempt to access the underlying CGColor
        guard let cgColor = self.cgColor else {
            return nil
        }
        
        // Extract color components
        guard let components = cgColor.components else {
            return nil
        }
        
        let colorSpaceModel = cgColor.colorSpace?.model
        
        switch colorSpaceModel {
        case .monochrome:
            // For grayscale, components = [gray, alpha]
            let gray = components[0]
            let alpha = components.count > 1 ? components[1] : 1.0
            
            let grayInt = Int(gray * 255)
            
            if includeAlpha {
                let alphaInt = Int(alpha * 255)
                return String(format: "#%02X%02X%02X%02X",
                              grayInt, grayInt, grayInt, alphaInt)
            } else {
                return String(format: "#%02X%02X%02X",
                              grayInt, grayInt, grayInt)
            }
            
        case .rgb:
            // For RGB, components = [red, green, blue, alpha]
            let red   = components[0]
            let green = components[1]
            let blue  = components[2]
            let alpha = components.count > 3 ? components[3] : 1.0
            
            let rInt = Int(red   * 255)
            let gInt = Int(green * 255)
            let bInt = Int(blue  * 255)
            
            if includeAlpha {
                let aInt = Int(alpha * 255)
                return String(format: "#%02X%02X%02X%02X", rInt, gInt, bInt, aInt)
            } else {
                return String(format: "#%02X%02X%02X", rInt, gInt, bInt)
            }
            
        default:
            // Unsupported color space (CMYK, Lab, etc.)
            return nil
        }
    }
}
