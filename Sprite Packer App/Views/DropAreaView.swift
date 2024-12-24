//
//  DropAreaView.swift
//  Sprite Packer
//
//  Created by James Randall on 21/12/2024.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers
let contentBackgroundColor = Color(red: 12.0/255.0, green: 15.0/255.0, blue: 18.0/255.0)

struct DropAreaView: View {
    @Binding var droppedImage: [PackableImage]
    @Binding var svgSettings: SvgSettings
    @Binding var canPackAll: Bool
    @Binding var isTargetted : Bool
    @Binding var warningImagePaths : Set<String>
    var outputSettings: OutputSettings
    var checkImages : () -> ()
    @State private var highlightedRow : String?
    
    
    var body: some View {
        VStack(spacing: 16.0) {
            ZStack {
                if (droppedImage.isEmpty) {
                    Text("Drop your images here").foregroundStyle(isTargetted ? Color.blue : Color.gray).animation(.easeInOut(duration: 0.3), value: isTargetted)
                }
                else {
                    ScrollView(.vertical) {
                        Grid {
                            ForEach(droppedImage, id:\.id) { packableImage in
                                PackableImageRow(
                                    packableImage: packableImage,
                                    isWarning: warningImagePaths.contains(packableImage.path),
                                    onRemove: {
                                        droppedImage.removeAll(where: { $0.path == packableImage.path } )
                                        checkImages()
                                    })
                            }
                        }
                        .padding()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay {
                ZStack {
                    if (droppedImage.isEmpty || isTargetted) {
                        RoundedRectangle(cornerRadius: 20.0)
                            .stroke(style: StrokeStyle(lineWidth: 2, dash: [15, 10]))
                            .foregroundColor(isTargetted ? .blue : .gray)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .padding()
                .animation(.easeInOut(duration: 0.3), value: isTargetted)
            }
            .background(contentBackgroundColor)
        }
    }
}
