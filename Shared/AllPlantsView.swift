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
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(model.plants) { plant in
                    NavigationLink(destination: PlantDetailView(plant: plant)) {
                        PlantCell(plant: plant)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color.systemGroupedBackground))
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                }
            
                Button(action: addPlant) {
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "plus.circle.fill").imageScale(.large)
                            Spacer()
                        }
                        
                        Text("Add New")
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.systemGroupedBackground))
                }.buttonStyle(PlainButtonStyle())
                
                HStack {
                    Spacer()
                }
            }
            .padding()
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("Plants")
        .navigationBarItems(trailing: Button(
            action: addPlant,
            label: {
                Image(systemName: "plus.circle.fill")
                    .imageScale(.large)
        })
        )
    }
    
    private func addPlant() {
        withAnimation {
            self.model.addPlant()
        }
    }
}

struct AllPlantsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AllPlantsView().environmentObject(GrowModel())
        }
    }
}
