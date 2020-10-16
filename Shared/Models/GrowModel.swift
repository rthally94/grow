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
        case configureTaskInterval(Binding<(CareTask.IntervalUnit, Set<Int>)>)
    }
    
    @Published var sheetToPresent: SheetStates? = nil
    
    func createPlant() {
        let plant = Plant.create(in: viewContext)
        sheetToPresent = .configurePlantNameAppearance(plant)
    }
    
    func delete(plant: Plant) {
        viewContext.delete(plant)
        try? viewContext.save()
    }
}
