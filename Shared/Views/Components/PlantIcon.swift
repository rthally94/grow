//
//  PlantIcon.swift
//  Grow iOS
//
//  Created by Ryan Thally on 10/15/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI

struct PlantIcon: View {
    var icon: Image
    var tint: Color
    
    init(systemName: String, color: Color = .blue) {
        self.init(Image(systemName: systemName), color: color)
    }
    
    init(named name: String, color: Color = .blue) {
        self.init(Image(name), color: color)
    }
    
    init(_ icon: Image, color: Color = .blue) {
        self.icon = icon
        self.tint = color
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(tint)
            icon
                .resizable()
                .scaledToFit()
                .scaleEffect(0.7)
                .foregroundColor(.systemGray6)
                .opacity(0.1)
        }
    }
}

struct PlantIcon_Previews: PreviewProvider {
    static var previews: some View {
        PlantIcon(systemName: "leaf.fill")
    }
}
