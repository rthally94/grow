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
    @Environment(\.managedObjectContext) var context
    @FetchRequest(entity: Plant.entity(), sortDescriptors: []) var plants: FetchedResults<Plant>
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(plants, id: \.id) { plant in
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
            let _ = Plant.create(context: context)
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
