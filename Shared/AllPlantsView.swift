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
                NavigationLink(plant.name, destination: Text(plant.name))
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Plants")
            .navigationBarItems(trailing: Button(
                action: {
                    withAnimation {
                        self.model.addPlant()
                    }
                },
                label: {
                    Image(systemName: "plus.circle")
                        .imageScale(.large)
                })
            )
        }
    }
}

struct AllPlantsView_Previews: PreviewProvider {
    static var previews: some View {
        AllPlantsView().environmentObject(GrowModel())
    }
}