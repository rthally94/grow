//
//  ListRow.swift
//  Grow iOS
//
//  Created by Ryan Thally on 7/14/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI

struct ListRow: View {
    var image: Image?
    var title: Text
    var value: Text
    
    init(image: Image? = nil, title: String?, value: String?) {
        self.init(image: image, title: Text(title ?? ""), value: Text(value ?? ""))
    }
    
    init(image: Image? = nil, title: Text, value: Text) {
        self.image = image
        self.title = title
        self.value = value
    }
    
    
    var body: some View {
        HStack {
            image
            title
            Spacer()
            value
                .opacity(0.7)
        }
    }
}

struct ListRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ListRow(image: Image(systemName: "gauge"), title: "Title", value: "Value")
            ListRow(title: "Title", value: "Value")
            ListRow(title: "Title", value: "Value")
        }
        .previewLayout(.sizeThatFits)
    }
}
