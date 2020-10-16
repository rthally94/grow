//
//  PlantDetailView.swift
//  Grow iOS
//
//  Created by Ryan Thally on 7/9/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI
import CoreData

struct PlantDetailView: View {
    @EnvironmentObject var growModel: GrowModel
    @Environment(\.managedObjectContext)
    var viewContext
    
    @ObservedObject var plant: Plant
    
    @State var plantActionSheetIsPresented = false
    @State var plantEditorSheetIsPresented = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                PlantHero(plant: plant)
                
                PlantCareTasks(plant: plant)
            }
            .padding(.horizontal)
        }
        .listStyle(GroupedListStyle())
        .navigationTitle(plant.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem {
                PlantEditMenu(plant: plant)
            }
        }
    }
    
    
    
    // MARK: Actions
    private func showActionSheet() {
        plantActionSheetIsPresented.toggle()
    }
    
    private func presentEditor() {
        self.plantEditorSheetIsPresented = true
    }
    
    // MARK: Intents
    private func deletePlant() {
        withAnimation {
            viewContext.delete(self.plant)
            try? viewContext.save()
        }
    }
    
    private func save() {
        try? viewContext.save()
        plant.objectWillChange.send()
        self.plantEditorSheetIsPresented = false
    }
    
    private func dismiss() {
        viewContext.rollback()
        self.plantEditorSheetIsPresented = false
    }
}

struct PlantDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let persistence = PersistenceController.preview
        
        let request: NSFetchRequest<Plant> = Plant.fetchRequest()
        request.fetchLimit = 1
        
        let plant = try?  persistence.container.viewContext.fetch(request).first
        
        let view = NavigationView {
            PlantDetailView(plant: plant!)
        }
        
        return Group {
            view
            view.environment(\.colorScheme, .dark)
        }
        .environment(\.managedObjectContext, persistence.container.viewContext)
        .environmentObject(GrowModel())
    }
}
