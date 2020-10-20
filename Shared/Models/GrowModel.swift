//
//  GrowModel.swift
//  Grow iOS
//
//  Created by Ryan Thally on 10/13/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI
import CoreData

class GrowModel: ObservableObject {
    let persistence = PersistenceController.shared
    var viewContext: NSManagedObjectContext {
        persistence.container.viewContext
    }
    
    enum SheetStates: Identifiable {
        var id: UUID { UUID() }
        
        case configurePlantNameAppearance(Plant)
        case configureTaskInterval(CareTask)
    }
    
    @Published var sheetToPresent: SheetStates? = nil
    
    func addNewPlant() {
        let plant = Plant.create(in: viewContext)
        editPlant(plant)
    }
    
    func editPlant(_ plant: Plant) {
        sheetToPresent = .configurePlantNameAppearance(plant)
    }
    
    func deletePlant(_ plant: Plant) {
        viewContext.delete(plant)
        try? viewContext.save()
    }
}
