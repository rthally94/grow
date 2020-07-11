//
//  PlantDetailView.swift
//  Grow iOS
//
//  Created by Ryan Thally on 7/9/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI

struct StatCell: View {
    let title: Text
    let subtitle: Text
    
    var body: some View {
        VStack {
            title
                .font(.subheadline)
                .padding(.bottom)
            
            subtitle.font(.headline)
        }
        .padding()
    }
    
    init(title: String, subtitle: String) {
        self.init(title: Text(title), subtitle: Text(subtitle))
    }
    
    init(title: Text, subtitle: Text) {
        self.title = title
        self.subtitle = subtitle
    }
}

struct StatRow<Content: View>: View {
    let content: [Content]
    
    init(_ content: Content...) {
        self.content = content
    }
    
    var body: some View {
        HStack {
            ForEach(0..<content.count) { index in
                Spacer()
                self.content[index]
                Spacer()
                if index < self.content.count - 1 {
                    Divider()
                }
            }
        }
    }
}

struct ListRow: View {
    var image: Image?
    var title: Text
    var value: Text
    
    init(image: Image? = nil, title: String?, value: String?) {
        self.init(image: image, title: Text(title ?? ""), value: Text(value ?? ""))
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
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var model: GrowModel
    @ObservedObject private(set) var plant: Plant
    
    @State private var plantActionSheetIsPresented = false
    
    var body: some View {
        List {
            StatRow(
                StatCell(title: "Watering", subtitle: plantWateringString),
                StatCell(title: "Pruning", subtitle: plantWateringString),
                StatCell(title: "Fertilizing", subtitle: plantWateringString)
            )
            
            Section(header: Text("Growing Conditions")) {
                ListRow(title: "Age", value: plantAgeString)
                ListRow(title: "Sun Tolerance", value: "NO VAL")
                ListRow(title: "Watering Interval", value: plant.wateringInterval?.description ?? "None")
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
                ForEach(plant.getLogs(max: 10)) { log in
                    ListRow(image: Image(systemName: "scissors"), title: log.type.description, value: Formatters.dateFormatter.string(from: log.date))
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(plant.name)
        .navigationBarItems(trailing: Button(action: showActionSheet) {
            Image(systemName: "ellipsis.circle")
        })
        
        .actionSheet(isPresented: $plantActionSheetIsPresented) {
            ActionSheet(title: Text("Plant Options"), buttons: [
                ActionSheet.Button.default(Text("Log Care Activity"), action: addCareActivity),
                ActionSheet.Button.destructive(Text("Delete Plant"), action: deletePlant)
            ])
        }
    }
    
    private func showActionSheet() {
        plantActionSheetIsPresented.toggle()
    }
    
    private func addCareActivity() {
        withAnimation {
            self.model.addCareActivity(.init(type: .water, date: Date()), to: self.plant)
        }
    }
    
    private func deletePlant() {
        withAnimation {
            self.presentationMode.wrappedValue.dismiss()
            self.model.deletePlant(plant: plant)
        }
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
    
    private var plantWateringString: String {
        if let interval = plant.wateringInterval {
            let next = interval.next(from: plant.lastWaterLog?.date ?? Date())
            return Formatters.relativeDateFormatter.string(for: next)
        } else {
            if let lastLogDate = plant.lastWaterLog?.date {
                return Formatters.dateFormatter.string(for: lastLogDate) ?? "Never"
            } else {
                return "Never"
            }
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
