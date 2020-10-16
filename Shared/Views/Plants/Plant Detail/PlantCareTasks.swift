//
//  PlantCareTasks.swift
//  Grow iOS
//
//  Created by Ryan Thally on 10/15/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI

struct PlantCareTasks: View {
    @FetchRequest(fetchRequest: CareTaskType.allBuiltInTypesRequest()) var builtInTaskTypes: FetchedResults<CareTaskType>
    @FetchRequest var careTasks: FetchedResults<CareTask>
    
    init(plant: Plant) {
        self._careTasks = FetchRequest(fetchRequest: CareTask.allTasksFetchRequest(for: plant))
    }
    
    var body: some View {
        Section(header:
            Text("Care Tasks")
                .font(.headline)
        ) {
            VStack(spacing: 20) {
                ForEach(builtInTaskTypes, id: \.self) { type in
                    if let task = careTasks.first(where: { $0.type == type }) {
                        CareTaskCardView(task: task)
                    }
                }
            }
        }
    }
}

struct PlantCareTasks_Previews: PreviewProvider {
    static var previews: some View {
        let plant = PersistenceController.previewPlant
        
        PlantCareTasks(plant: plant)
    }
}
