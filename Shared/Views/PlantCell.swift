//
//  PlantCell.swift
//  Grow iOS
//
//  Created by Ryan Thally on 7/27/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI
import CoreData

struct IconImage: View {
    var icon: Image
    
    init(systemName: String) {
        icon = Image(systemName: systemName)
    }
    
    init(_ name: String) {
        icon = Image(name)
    }
    
    var body: some View {
        ZStack {
            Image(systemName: "circle.fill").opacity(0.5)
            icon.scaleEffect(0.6)
        }
    }
}

struct PlantCell: View {
    @ObservedObject var plant: PlantMO
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                //                IconImage(systemName: "person.fill")
                //                    .imageScale(.large)
                //                    .foregroundColor(.blue)
                
                Text(plant.name).font(.headline)
                Text("\(plant.careTasks.count == 0 ? "No" : "\(plant.careTasks.count)") Tasks").opacity(0.8).font(.subheadline)
            }
            
            Spacer()
        }
        .padding()
    }
}

struct PlantCell_Previews: PreviewProvider {
    static var previews: some View {
        let plant = PlantMO(context: .init(concurrencyType: .mainQueueConcurrencyType))
        
        return
            PlantCell(plant: plant)
                .padding()
                .background(RoundedRectangle(cornerRadius: 15).fill(Color.systemGroupedBackground))
    }
}
