//
//  PlantDetailView.swift
//  Grow iOS
//
//  Created by Ryan Thally on 7/9/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI

struct ListRow: View {
    
    var image: Image?
    var title: Text
    var value: Text
    
    init(image: Image? = nil, title: String, value: String) {
        self.init(image: image, title: Text(title), value: Text(value))
    }
    
    init(image: Image? = nil, title: Text, value: Text) {
        self.image = image
        self.title = title
        self.value = value
    }
    
    
    var body: some View {
        HStack {
            image
            title
            Spacer()
            value
        }
    }
}

struct PlantDetailView: View {
    @EnvironmentObject var model: GrowModel
    private(set) var plant: Plant
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            List {
                Section(header: Text("Growing Conditions")) {
                    ListRow(title: "Age", value: plantAgeString)
                    ListRow(title: "Sun Tolerance", value: "NO VAL")
                }
                
                Section(header:
                    HStack {
                        Text("Recent Care Activity")
                        Spacer()
                        Button("View All") {
                            print("Pressed")
                        }
                    }
                ) {
                    ForEach(plant.getLogs()) { log in
                        ListRow(image: Image(systemName: "scissors"), title: log.type.description, value: Formatters.dateFormatter.string(from: log.date))
                    }
                }
            }
            .listStyle(GroupedListStyle())
            
            Button("Care") {
                self.model.addCareActivity(.init(type: .water, date: Date()), to: self.plant)
            }.padding()
        }
        .navigationBarTitle(plant.name)
    }
}


extension PlantDetailView {
    private var plantAgeString: String {
        if let potted = plant.pottingDate, let ageString = Formatters.dateComponentsFormatter.string(from: potted, to: Date()) {
            return "Potted \(ageString) ago"
        } else {
            return "Not Potted Yet"
        }
    }
}


struct PlantDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let model = GrowModel()
        model.addPlant()
        
        let view = NavigationView {
            PlantDetailView(plant: model.plants[0]).environmentObject(model)
        }
        
        return view
    }
}
