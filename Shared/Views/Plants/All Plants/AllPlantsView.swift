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
    @Environment(\.managedObjectContext)
    var viewContext
    
    @EnvironmentObject var growModel: GrowModel
    
    var body: some View {
        PlantsListView()
            .navigationTitle("Your Plants")
            .toolbar {
                ToolbarItem {
                    Button( action: addPlant,
                            label: {
                                Image(systemName: "plus.circle.fill")
                                    .imageScale(.large)
                            })
                }
            }
    }
    private func addPlant() {
        withAnimation {
            growModel.createPlant()
        }
    }
}

struct PlantsListView: View {
    @FetchRequest(fetchRequest: Plant.allPlantsFetchRequest())
    var plants: FetchedResults<Plant>
    
    @Environment(\.managedObjectContext)
    var viewContext
    
    @EnvironmentObject var growModel: GrowModel
    
    var body: some View {
        ScrollView {
            Group {
                if !plants.isEmpty {
                    LazyVGrid(columns: Array(repeating: GridItem(spacing: 20), count: 2)) {
                        ForEach(plants, id: \.self) { plant in
                            VStack {
                                NavigationLink(destination: PlantDetailView(plant: plant)) {
                                    PlantCell(plant: plant)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                } else {
                    Button(action: addPlant) {
                        VStack {
                            Spacer()
                            
                            Image(systemName: "plus")
                                .imageScale(.large)
                            Spacer()
                            
                            Text("Add New")
                            
                            Spacer()
                            HStack {
                                Spacer()
                            }
                        }
                        .foregroundColor(.accentColor)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 15).fill(Color.systemGroupedBackground))
                    }.buttonStyle(PlainButtonStyle())
                    
                    HStack {
                        Spacer()
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    private func addPlant() {
        withAnimation {
            growModel.createPlant()
        }
    }
}

struct AllPlantsView_Previews: PreviewProvider {
    static var previews: some View {
        let persistence = PersistenceController.preview
        
        return NavigationView {
            AllPlantsView()
        }.environment(\.managedObjectContext, persistence.container.viewContext)
    }
}
