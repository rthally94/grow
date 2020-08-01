//
//  PlantCell.swift
//  Grow iOS
//
//  Created by Ryan Thally on 7/27/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI

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
    @EnvironmentObject var model: GrowModel
    var plant: Plant
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                //                IconImage(systemName: "person.fill")
                //                    .imageScale(.large)
                //                    .foregroundColor(.blue)
                
                Text(plant.name).font(.headline)
                Text("\(plant.careTasks.count == 0 ? "No" : "\(plant.careTasks.count)") Task").opacity(0.8).font(.subheadline)
            }
            
            Spacer(minLength: 16)
            Button(action: toggleFavorite, label: {Image(systemName: plant.isFavorite ? "star.fill" : "star")})
        }
    }
    
    func toggleFavorite() {
        model.setPlantFavorite(!plant.isFavorite, for: plant)
    }
}

struct PlantCell_Previews: PreviewProvider {
    static var previews: some View {
        PlantCell(plant: Plant()).environmentObject(GrowModel())
            .padding()
            .background(RoundedRectangle(cornerRadius: 15).fill(Color.systemGroupedBackground))
    }
}
