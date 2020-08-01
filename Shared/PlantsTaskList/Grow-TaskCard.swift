//
//  Grow-TaskCard.swift
//  Grow iOS
//
//  Created by Ryan Thally on 8/1/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI

struct Grow_TaskCard: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Title").font(.headline)
                    Text("Subtitle").font(.subheadline)
                }
                Spacer()
            }
            .padding()
            .background(background().foregroundColor(Color(red: 0.33, green: 0.60, blue: 0.61)))
            
            VStack {
                ForEach(0..<4) { _ in
                    HStack {
                        Image(systemName: "square")
                        Text("Plant Name")
                        Spacer()
                    }
                }
            }
            .padding()
        }
        .background(background().foregroundColor(.systemGroupedBackground))
    }
    
    @ViewBuilder func background() -> some View {
        RoundedRectangle(cornerRadius: 15)
    }
    
    
}

struct Grow_TaskCard_Previews: PreviewProvider {
    static var previews: some View {
        Grow_TaskCard()
            .previewLayout(.sizeThatFits)
    }
}
