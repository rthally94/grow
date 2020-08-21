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
    let careTask: CareTask
    var firstFourPlants: [Plant] = []
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text(careTask.type?.name ?? "").font(.headline)
                    Text("\(careTask.logs.count)").font(.subheadline)
                }
                Spacer()
            }
            .padding()
            VStack {
                ForEach(firstFourPlants, id: \.self) { plant in
                    HStack {
                        Image(systemName: "square")
                        Text("f")
                        Spacer()
                    }
                }
            }
            .padding()
        }
        .background(background().foregroundColor(.systemGroupedBackground))
    }
    
    @ViewBuilder func background() -> some View {
        RoundedRectangle(cornerRadius: 25)
    }
    
    
}

struct Grow_TaskCard_Previews: PreviewProvider {
    static var previews: some View {
        let task = CareTask(type: CareTaskType(name: "Default"), interval: CareInterval(), notes: "", logs: [])
        
        return GrowTaskCard(careTask: task)
            .previewLayout(.sizeThatFits)
    }
}
