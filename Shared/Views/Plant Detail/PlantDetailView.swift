//
//  PlantDetailView.swift
//  Grow iOS
//
//  Created by Ryan Thally on 7/9/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI
import CoreData

class PlantDetailViewModel: ObservableObject {
    @Published var plant: Plant
    @Published var plantActionSheetIsPresented = false
    @Published var plantEditorSheetIsPresented = false
    
    var careTasks: [CareTask] {
        plant.careTasks
    }
    
    init(plant: Plant) {
        self.plant = plant
    }
}

struct PlantDetailView: View {
    @EnvironmentObject var growModel: GrowModel
    @ObservedObject var model: PlantDetailViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Text(ageValue)
                    Spacer()
                }.padding(.bottom)
                
                if model.plant.careTasks.count > 0 {
                    Section(header:
                        Text("Care Tasks")
                        .font(.headline)
                    ) {
                        VStack(spacing: 20) {
                            ForEach(Array(model.careTasks)) { task in
                                StatCell(title: Text(task.type?.name ?? "")) {
                                    Text(task.interval.description)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.systemGroupedBackground))
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .navigationBarTitle(model.plant.name)
        .navigationBarItems(trailing: Button(action: showActionSheet) {
            Image(systemName: "ellipsis.circle")
                .imageScale(.large)
        })
            .actionSheet(isPresented: $model.plantActionSheetIsPresented) {
                ActionSheet(title: Text("Options"), buttons: [
                    ActionSheet.Button.default(Text("Edit Plant"), action: presentEditor),
                    ActionSheet.Button.destructive(Text("Delete Plant"), action: deletePlant),
                    ActionSheet.Button.cancel()
                ])
        }
        .sheet(isPresented: $model.plantEditorSheetIsPresented) {
            NavigationView {
                PlantEditorForm(isPresented: self.$model.plantEditorSheetIsPresented, plant: self.model.plant)
            }
            .environmentObject(self.growModel)
        }
    }
    
    // MARK: Actions
    private func showActionSheet() {
        model.plantActionSheetIsPresented.toggle()
    }

    private func presentEditor() {
        model.plantEditorSheetIsPresented.toggle()
    }
    
    // MARK: Intents
    private func deletePlant() {
        withAnimation {
            growModel.removePlant(model.plant)
        }
    }
}

// MARK: Computed Properties
extension PlantDetailView {
//    var plantIndex: Int {
//        guard let plantIndex =  model.plants.firstIndex(of: plant) else { fatalError("Plant must be in model to be in detail view.") }
//        return plantIndex
//    }
    
    //    var careTaskLogCount: String {
    //        "\(plant.careTaskLogs.count)"
    //    }
    //
    //    var plantWateringTitle: String {
    //        plant.wateringInterval.unit == .none ? "Watered" : "Watering"
    //    }
    //
    //    var plantWateringValue: String {
    //        // Check if plant has a care interval
    //        if plant.wateringInterval.unit == .none {
    //            // Format for next care activity
    //            let next = plant.wateringInterval.next(from: plant.careActivity.first?.date ?? Date())
    //            return Formatters.relativeDateFormatter.string(for: next)
    //        } else {
    //            // Check if a log has been recorded
    //            if let lastLogDate = plant.careActivity.first?.date {
    //                // Display the date of the last log
    //                return Formatters.relativeDateFormatter.string(for: lastLogDate)
    //            } else {
    //                return "Never"
    //            }
    //        }
    //    }
    
    // Growing Conditions
    var ageValue: String {
        let ageString: String
        
        if let plantingDate = model.plant.plantingDate {
            ageString = "Planted " + Formatters.relativeDateFormatter.string(for: plantingDate)
        } else {
            ageString = "Not planted"
        }
        
        return ageString
    }
    
    //    var wateringIntervalValue: String {
    //        plant.wateringInterval.unit == .none ? "Watered" : "Watering"
    //    }
}

struct PlantDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let model = GrowModel(context: .init(concurrencyType: .mainQueueConcurrencyType))
        let plant = Plant(name: "My New Plant")
        
        model.addPlant(plant)
        
        let view = NavigationView {
            PlantDetailView(model: .init(plant: plant))
        }
        
        return Group {
            view
            view.environment(\.colorScheme, .dark)
        }
        .environmentObject(model)
    }
}
