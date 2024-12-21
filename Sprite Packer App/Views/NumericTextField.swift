//
//  NumericTextField.swift
//  Sprite Packer
//
//  Created by James Randall on 21/12/2024.
//

import SwiftUI
import Combine

struct NumericTextField: View {
    private var label: String
    @Binding private var text: String
    
    init(_ label: String, text: Binding<String>) {
        self.label = label
        self._text = text
    }
    
    var body: some View {
        TextField(label, text: $text)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .onReceive(Just(text)) { newValue in
                // Filter out non-digit characters
                let filtered = newValue.filter { "0123456789".contains($0) }
                if filtered != newValue {
                    self.text = filtered
                }
            }
    }
}
