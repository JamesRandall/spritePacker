//
//  IconView.swift
//  Sprite Packer Icon
//
//  Created by James Randall on 21/12/2024.
//

import SwiftUI

let rows = [
    [
        [253,230,8],
        [252,227,1],
        [252,224,1],
        [253,191,0],
        [255,118,48]
    ],
    [
        [9,166,254],
        [23,200,255],
        [255,126,14],
        [253,184,0],
        [254,38,107]
    ],
    [
        [255,181,0],
        [254,114,36],
        [255,146,19],
        [11,179,252],
        [158,64,254]
    ],
    [
        [4,137,254],
        [255,70,60],
        [217,239,230],
        [157,243,57],
        [0,133,255]
    ],
    [
        [20,214,196],
        [61,237,100],
        [27,221,222],
        [Int(26 * 2.5),Int(42 * 2.5),Int(71 * 2.5)],
        [65,251,254]
    ]
]



struct AppIconView : View {
    var width: CGFloat = 1024
    var height : CGFloat = 1024
    var cornerRadius : CGFloat = 204
    var innerCornerRadius: CGFloat = 32
    var spacing : CGFloat = 30
    
    var magnification = 1.0
    
    var body: some View {
        ZStack {
            ZStack {
                VStack(spacing: spacing * magnification) {
                    ForEach(Array(rows.enumerated()), id: \.offset) { row in
                        HStack(spacing: spacing * magnification) {
                            ForEach(Array(row.element.enumerated()), id: \.offset) { _,column in
                                RoundedRectangle(cornerRadius: innerCornerRadius * magnification)
                                    .fill(Color(red: CGFloat(column[0]) / 255.0, green: CGFloat(column[1]) / 255.0, blue: CGFloat(column[2]) / 255.0))
                            }
                        }
                    }
                }
                .padding(spacing * magnification)
            }
            .background(Color(red: 8.0/255.0, green: 22.0/255.0, blue: 49.0/255.0))
            .cornerRadius(cornerRadius * magnification)
            .frame(width: (width - cornerRadius) * magnification, height: (height - cornerRadius)  * magnification)
        }
        .frame(width: width * magnification, height: height * magnification)
        .background(Color.clear)
    }
}
