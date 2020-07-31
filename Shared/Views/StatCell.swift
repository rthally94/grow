//
//  StatCell.swift
//  Grow iOS
//
//  Created by Ryan Thally on 7/14/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI

struct StatCell<Content: View>: View {
    let title: Text
    let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading) {
            self.title
                .opacity(0.8)
            HStack {
                content()
            }.font(.headline)
        }
    }
    
    init(title: String, @ViewBuilder content: @escaping () -> Content) {
        self.init(title: Text(title), content: content)
    }
    
    init(title: Text, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }
}

struct StatCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
//            StatCell(title: "Title", subtitle: "Subtitle")
            StatCell(title: Text("Title"), content: {
                Image(systemName: "cloud")
                Text("Content")
            })
        }
        .previewLayout(.sizeThatFits)
    }
}
