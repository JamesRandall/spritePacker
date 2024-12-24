//
//  PackableImageRow.swift
//  Sprite Packer
//
//  Created by James Randall on 23/12/2024.
//

import SwiftUI

private let trashIcon = Image("trash-can")
private let warningIcon = Image("warning")

struct PackableImageRow: View {
    let packableImage: PackableImage
    let isWarning: Bool
    let onRemove : () -> Void
    @State private var isHovered = false
    
    var body: some View {
        GridRow {
            let image = NSImage(cgImage: packableImage.image, size: NSSize(width:packableImage.width, height: packableImage.height))
            if image.size.width > 160.0 || image.size.height > 100.0 {
                Image(nsImage: image).resizable().scaledToFit().frame(width: 160, height: 100)
            }
            else {
                ZStack {
                    Image(nsImage: image)
                }.frame(width: 160, height: 100)
            }
            Text("\(Int(image.size.width)) x \(Int(image.size.height))")
            Text(packableImage.path).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            warningIcon.opacity(isWarning ? 1.0 : 0.0)
            ToolbarButton(action: { self.onRemove() }, icon: trashIcon)
                .opacity(isHovered ? 1.0 : 0.2)
                //.background(Color.clear)
            /*ToolbarButton(action: { self.onRemove() }, icon: trashIcon)
                .background(Color(red: 203.0/255.0, green: 43.0/255.0, blue: 43.0/255.0))
                .opacity(isHovered ? 1.0 : 0.0)
                .cornerRadius(8.0)*/
        }
        .padding([.bottom, .top], 8.0)
        .onHover(perform: { isHover in isHovered = isHover })
        .contextMenu {
            Button(action: { self.onRemove() }) { Text("Remove") }
        }
    }
}
