//
//  ContentView.swift
//  Grow
//
//  Created by Ryan Thally on 7/8/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI

struct AllPlantsView: View {
    @EnvironmentObject var model: GrowModel
    
    var body: some View {
        NavigationView {
            List(model.plants) { plant in
                NavigationLink(plant.name, destination: PlantDetailView(viewModel: .init(model: self.model, plant: plant)))
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Plants")
            .navigationBarItems(trailing: Button(
                action: addPlant,
                label: {
                    Image(systemName: "plus.circle")
                })
            )
        }
    }
    
    private func addPlant() {
        withAnimation {
            self.model.addPlant()
        }
    }
}

struct AllPlantsView_Previews: PreviewProvider {
    static var previews: some View {
        AllPlantsView().environmentObject(GrowModel())
    }
}
