//
//  SvgHandling.swift
//  Sprite Packer
//
//  Created by James Randall on 19/12/2024.
//

import AppKit
import SVGKit

func convertSvgToImage(path: String, svgSettings: SvgSettings) -> NSImage? {
    //let svgSource = SVGKSourceLocalFile()
    //svgSource.filePath = path
    guard let svgImage = SVGKImage(contentsOfFile: path) else {
        print("Could not load SVG file.")
        return nil
    }
    
    guard let rootElement = svgImage.domDocument.rootElement else {
        print("Could not access root element of the SVG.")
        return nil
    }
    
    //rootElement.setAttribute("svg:fill", value: "#ff0000")
    if svgSettings.shouldFill {
        let hexColor = svgSettings.fill.toHex()
        rootElement.setAttributeNS("http://www.w3.org/2000/svg", qualifiedName: "fill", value: hexColor)
    }
    
    guard let nsImage = svgImage.nsImage else {
        print("Could not create NSImage from SVGKImage.")
        return nil
    }
    
    if !svgSettings.scaleToFit {
        return nsImage
    }
    
    if let intWidth = Int(svgSettings.widthText), let intHeight = Int(svgSettings.heightText) {
        let width = CGFloat(intWidth)
        let height = CGFloat(intHeight)
        return nsImage.scaledToFitCentered(in: NSSize(width: width, height: height))
    }
    return nil
}
