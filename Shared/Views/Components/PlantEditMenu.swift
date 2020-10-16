//
//  PlantEditMenuItems.swift
//  Grow iOS
//
//  Created by Ryan Thally on 10/14/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI
import CoreData

struct PlantEditMenu: View {
    @EnvironmentObject var growModel: GrowModel
    
    let plant: Plant
    
    var body: some View {
        Menu(content: {
            Button(action: { growModel.sheetToPresent = .configurePlantNameAppearance(plant)}, label: {
                Label("Name and Appearance", systemImage: "pencil")
            })
            
            Button(action: { growModel.delete(plant: plant) }, label: {
                Label("Delete", systemImage: "trash")
            })
        }, label: {
            Label("Edit", systemImage: "ellipsis.circle.fill")
                .imageScale(.large)
                .padding(2)
        })
    }
}

struct PlantEditMenuItems_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.preview.container.viewContext
        let request: NSFetchRequest<Plant> = Plant.allPlantsFetchRequest()
        request.fetchLimit = 1
        let plant = try? viewContext.fetch(request).first
        
        return PlantEditMenu(plant: plant!)
            .environment(\.managedObjectContext, viewContext)
            .environmentObject(GrowModel())
    }
}
