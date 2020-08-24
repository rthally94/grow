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

class PlantCellViewModel: ObservableObject {
    @Published var plant: Plant
    
    init(plant: Plant) {
        self.plant = plant
    }
}

struct PlantCell: View {
    @ObservedObject var model: PlantCellViewModel
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                //                IconImage(systemName: "person.fill")
                //                    .imageScale(.large)
                //                    .foregroundColor(.blue)
                
                Text(model.plant.name).font(.headline)
                Text("\(model.plant.careTasks.count == 0 ? "No" : "\(model.plant.careTasks.count)") Task").opacity(0.8).font(.subheadline)
            }
            
            Spacer()
        }
        .padding()
    }
}

struct PlantCell_Previews: PreviewProvider {
    static var previews: some View {
        let plant = Plant(name: "My Plant", careTasks: [])
        return
            PlantCell(model: .init(plant: plant))
                .padding()
                .background(RoundedRectangle(cornerRadius: 15).fill(Color.systemGroupedBackground))
    }
}
