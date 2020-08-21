//
//  ContentView.swift
//  Grow
//
//  Created by Ryan Thally on 7/8/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI
import CoreData

struct AllPlantsView: View {
    @EnvironmentObject var growModel: GrowModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("\(growModel.plants.first?.name ?? "NONE")")
                if !growModel.plants.isEmpty {
                    ForEach(growModel.plants) { plant in
                        VStack {
                            Text(plant.name)
                            NavigationLink(destination: PlantDetailView(plant: plant)) {
                                PlantCell(plant: plant)
                                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.systemGroupedBackground))
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                } else {
                    HStack {
                        Spacer()
                    }
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
            }
            .padding(.horizontal)
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
            growModel.addPlant()
        }
    }
}

struct AllPlantsView_Previews: PreviewProvider {
    static var previews: some View {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        return NavigationView {
            AllPlantsView()
        }.environment(\.managedObjectContext, context)
    }
}
