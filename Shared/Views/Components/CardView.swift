//
//  CardView.swift
//  Grow iOS
//
//  Created by Ryan Thally on 10/15/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI

struct CardView<Title: View, Subtitle: View, Background: View>: View {
    let title: Title
    let subtitle: Subtitle
    let background: Background
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            background
            
            VStack(alignment: .leading) {
                title
                subtitle
                    .opacity(0.8)
            }
            .shadow(radius: 10)
            .padding()
        }
    }
}

extension CardView where Subtitle == EmptyView {
    init(title: Title, background: Background) {
        self.init(title: title, subtitle: EmptyView(), background: background)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let title = Text("Title")
        let subtitle = Text("Subtitle")
        let background = RoundedRectangle(cornerRadius: 10).foregroundColor(.blue)
        
        return CardView(
            title: title,
            subtitle: subtitle,
            background: background
        )
        .previewLayout(.sizeThatFits)
    }
}
