//
//  PlantCell.swift
//  Grow iOS
//
//  Created by Ryan Thally on 7/27/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI
import CoreData

struct PlantCell: View {
    @ObservedObject var plant: Plant
    
    var taskLabelText: String {
        switch plant.careTasks.count {
        case 0:
            return "No Tasks"
        case 1:
            if let task = plant.careTasks.first {
                return task.type.name
            } else {
                return "1 Task"
            }
        default: return "\(plant.careTasks.count) Tasks"
        }
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
            title: Text(plant.name).font(.headline),
            subtitle: Text(taskLabelText).font(.subheadline),
            background: backgroundImage
        )
    }
        
}

struct PlantCell_Previews: PreviewProvider {
    static var previews: some View {
        let persistence = PersistenceController.preview
        
        let request: NSFetchRequest<Plant> = Plant.allPlantsFetchRequest()
        request.fetchLimit = 1
        
        let plant = try? persistence.container.viewContext.fetch(request).first
        
        return
            PlantCell(plant: plant!)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
