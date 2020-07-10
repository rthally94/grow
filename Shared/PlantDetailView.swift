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
    private(set) var plant: Plant
    
    var body: some View {
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
                ListRow(image: Image(systemName: "scissors"), title: "Pruning", value: plantAgeString)
            }
        }
        .listStyle(GroupedListStyle())
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
        let plant = Plant(id: UUID(), name: "My Plant", pottingDate: Date(), wateringInterval: CareInterval())
        
        let view = NavigationView {
            PlantDetailView(plant: plant)
        }
        
        return view
    }
}
