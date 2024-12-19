//
//  ToolbarButton.swift
//  Sprite Packer
//
//  Created by James Randall on 19/12/2024.
//

import SwiftUI

struct ToolbarButton : View {
    var action: () -> ()
    var text: String
    
    var body: some View {
        Button(action:self.action) {
            HStack {
                Text(text)
                    .padding([.leading, .trailing], 32.0)
                    .padding([.top, .bottom], 8.0)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .contentShape(Rectangle())
    }
}

