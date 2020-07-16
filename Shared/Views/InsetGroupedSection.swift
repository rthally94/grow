//
//  InsetGroupedSection.swift
//  Grow iOS
//
//  Created by Ryan Thally on 7/14/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI

struct InsetGroupedSection<Header: View, Content: View>: View {
    let header: () -> Header
    var content: () -> Content
    
    var body: some View {
        VStack {
            header().padding(.bottom)
            content()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(.systemGroupedBackground)
        )
    }
    
    init(header: @escaping () -> Header, @ViewBuilder content: @escaping () -> Content) {
        self.header = header
        self.content = content
    }
}

extension InsetGroupedSection where Header == EmptyView {
    init(@ViewBuilder content: @escaping () -> Content) {
        self.init(
            header: {EmptyView()},
            content: content)
    }
}

struct InsetGroupedSection_Previews: PreviewProvider {
    static var previews: some View {
        InsetGroupedSection(header: {
            Text("Header")
        }) {
            Text("Content")
        }
    }
}
