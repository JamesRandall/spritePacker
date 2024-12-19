//
//  TabPicker.swift
//  Sprite Packer
//
//  Created by James Randall on 19/12/2024.
//

import SwiftUI

struct TabPickerHeading<TType : Hashable> : Identifiable {
    var label: String
    let id: TType
}

struct TabPicker<TType : Hashable> : View {
    var headings: [TabPickerHeading<TType>]
    @Binding var selected: TType
    var reset: TType
    var selectedColor = Color(red: 58.0/255.0, green: 81.0/255.0, blue: 113.0/255.0)
    var backgroundColor = Color(NSColor.windowBackgroundColor) // Color(red: 31.0/255.0, green: 31.0/255.0, blue: 30.0/255.0)
    var borderColor = Color(red: 54.0/255.0, green: 53.0/255.0, blue: 53.0/255.0)
    
    var body: some View {
        HStack(spacing:0) {
            ForEach(headings) { heading in
                ToolbarButton(action: {
                    if selected == heading.id {
                        selected = reset
                    } else {
                        selected = heading.id
                    }
                }, text: heading.label)
                .background(selected == heading.id ? selectedColor : Color.clear)
            }
            Spacer()
        }
    }
}
