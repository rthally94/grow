//
//  RootView.swift
//  Grow iOS
//
//  Created by Ryan Thally on 7/13/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var growModel: GrowModel
    
    var body: some View {
        TabView {
            NavigationView {
                PlantsTaskList()
            }
            .tabItem {
                VStack {
                    Image(systemName: "heart.fill")
                    Text("Tasks")
                }
            }
            
            NavigationView {
                AllPlantsView()
            }
            .tabItem {
                VStack {
                    Image(systemName: "list.dash")
                    Text("Plants")
                }
            }
        }
        .sheet(item: $growModel.selectedPlantForEditing) { plant in
            NavigationView {
                PlantEditorForm(plant: plant)
            }
            .accentColor(.GrowGreen2)
            .environmentObject(self.growModel)
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
