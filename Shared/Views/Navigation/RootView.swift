//
//  RootView.swift
//  Grow iOS
//
//  Created by Ryan Thally on 7/13/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI

struct RootView: View {
    @StateObject var model = GrowModel()
    
    var body: some View {
        TabView {
            NavigationView {
                PlantsTaskList()
            }
            .tabItem {
                VStack {
                    tasksIcon
                    Text("Tasks")
                }
            }
            NavigationView {
                AllPlantsView()
            }
            .tabItem {
                VStack {
                    plantsIcon
                    Text("Plants")
                }
            }
        }
        .environmentObject(model)
        .sheet(item: $model.sheetToPresent) { sheet in
            NavigationView {
                switch sheet {
                    case .configurePlantNameAppearance(let plant):
                        PlantNameAppearanceEditorView(plant: plant)
                
                    case .configureTaskInterval(let task):
                        IntervalPicker()
                        .navigationBarTitle("Change Interval", displayMode: .inline)
                }
            }
            .environmentObject(model)
        }
    }
    
    // MARK: Constants
    private let tasksIcon = Image(systemName: "calendar")
    private let plantsIcon = Image(systemName: "list.dash")
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
