//
//  StatCell.swift
//  Grow iOS
//
//  Created by Ryan Thally on 7/14/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI

struct StatCell<Content: View>: View {
    let title: Text?
    let icon: Image?
    let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                icon?
                    .renderingMode(.template)
                    .imageScale(.small)
                
                self.title?
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Spacer()
            }
            .foregroundColor(.blue)
            .opacity(0.8)
            
            HStack {
                content()
            }.font(.system(size: 18, weight: .semibold, design: .rounded))
        }
    }
    
    init(title: String, iconSystemName: String, @ViewBuilder content: @escaping () -> Content) {
        self.init(title: Text(title), icon: Image(systemName: iconSystemName), content: content)
    }
    
    init(title: String, iconName: String, @ViewBuilder content: @escaping () -> Content) {
        self.init(title: Text(title), icon: Image(iconName), content: content)
    }
    
    init(title: Text? = nil, icon: Image? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.icon = icon
        self.content = content
    }
}

struct StatCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
//            StatCell(title: "Title", subtitle: "Subtitle")
            StatCell(title: Text("Title"), icon: Image(systemName: "flame"), content: {
                Image(systemName: "cloud")
                Text("Content")
            })
        }
        .previewLayout(.sizeThatFits)
    }
}
