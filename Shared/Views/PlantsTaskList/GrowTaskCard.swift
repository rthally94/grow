//
//  Grow-TaskCard.swift
//  Grow iOS
//
//  Created by Ryan Thally on 8/1/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI
import CoreData

struct GrowTaskCard: View {
    let careTasks: [CareTaskMO]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text(careTasks[0].type.name).font(.headline)
                    Text("\(careTasks.count)").font(.subheadline)
                }
                Spacer()
            }
        }
        .background(background().foregroundColor(.systemGroupedBackground))
    }
    
    @ViewBuilder func background() -> some View {
        RoundedRectangle(cornerRadius: 25)
    }
    
    
}

struct Grow_TaskCard_Previews: PreviewProvider {
    static var previews: some View {
        let task = CareTaskMO(context: .init(concurrencyType: .mainQueueConcurrencyType))
        
        return GrowTaskCard(careTasks: [task])
            .previewLayout(.sizeThatFits)
    }
}
