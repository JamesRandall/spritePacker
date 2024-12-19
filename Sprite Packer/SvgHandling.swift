//
//  SvgHandling.swift
//  Sprite Packer
//
//  Created by James Randall on 19/12/2024.
//

import AppKit
import SVGKit

func convertSvgToImage(path: String) -> NSImage? {
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
    rootElement.setAttributeNS("http://www.w3.org/2000/svg", qualifiedName: "fill", value: "#ff0000")
    
    guard let nsImage = svgImage.nsImage else {
        print("Could not create NSImage from SVGKImage.")
        return nil
    }
    
    return nsImage
}
