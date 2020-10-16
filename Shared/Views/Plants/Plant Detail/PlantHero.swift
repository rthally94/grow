//
//  PlantHero.swift
//  Grow iOS
//
//  Created by Ryan Thally on 10/15/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI

struct PlantHero: View {
    @ObservedObject var plant: Plant
    
    var titleText: some View {
        Text(plant.name)
            .font(.largeTitle)
            .fontWeight(.bold)
    }
    
    var backgroundImage: some View {
        if let image = plant.icon {
            return PlantIcon(Image(uiImage: image), color: Color(plant.tintColor))
        } else {
            return PlantIcon(systemName: "leaf.fill")
        }
    }
    
    var body: some View {
        CardView(
            title: titleText,
            background: backgroundImage
        )
    }
}

struct PlantHero_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.preview.container.viewContext
        let request = Plant.allPlantsFetchRequest()
        request.fetchLimit = 1
        
        let plant = try? viewContext.fetch(request).first
        
        return PlantHero(plant: plant!)
    }
}
