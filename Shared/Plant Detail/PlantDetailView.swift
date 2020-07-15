//
//  PlantDetailView.swift
//  Grow iOS
//
//  Created by Ryan Thally on 7/9/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI

struct PlantDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    
    // Model State
    @ObservedObject var viewModel: PlantDetailViewModel
    
    // View State
    @State private var plantActionSheetIsPresented = false
    @State private var plantEditorSheetIsPresented = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                Text(self.viewModel.ageValue)
                InsetGroupedSection( header: {
                    HStack {
                        Group {
                            Image(systemName: "heart.fill")
                            Text("Care Activity")
                        }
                        .font(.headline)
                        
                        Spacer()
                        Group {
                            Text(self.viewModel.careActivityCount)
                            Button(action: {}, label: {Image(systemName: "chevron.right")})
                        }
                        .foregroundColor(.gray)
                        .font(.caption)
                    }
                }) {
                    HStack(alignment: .bottom) {
                        StatCell(title: Text(self.viewModel.plantWateringTitle)) { Text(self.viewModel.plantWateringValue) }
                        Spacer()
                    }
                    .animation(.none)
                }
                
                InsetGroupedSection(header: {
                    HStack {
                        Group {
                            Image(systemName: "scissors")
                            Text("Growing Conditions")
                        }
                        .font(.headline)
                        
                        Spacer()
                    }
                }) {
                    VStack(spacing: 20) {
                        HStack {
                            Group {
                                StatCell(title: Text("Sun Tolerance")) {
                                    Text("No Val")
                                }
                                StatCell(title: Text("Watering")) { Text(self.viewModel.plantWateringValue) }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .navigationBarTitle(viewModel.name)
        .navigationBarItems(trailing: Button(action: showActionSheet) {
            Image(systemName: "ellipsis.circle")
        })
            .actionSheet(isPresented: $plantActionSheetIsPresented) {
                ActionSheet(title: Text("Options"), buttons: [
                    ActionSheet.Button.default(Text("Log Care Activity"), action: addCareActivity),
                    ActionSheet.Button.default(Text("Edit Plant"), action: {self.plantEditorSheetIsPresented = true}),
                    ActionSheet.Button.destructive(Text("Delete Plant"), action: deletePlant),
                    ActionSheet.Button.cancel()
                ])
        }
        .sheet(isPresented: $plantEditorSheetIsPresented, content: { PlantEditorForm(plant: self.viewModel.plant) })
    }
    
    // MARK: Actions
    private func showActionSheet() {
        plantActionSheetIsPresented.toggle()
    }
    
    private func addCareActivity() {
        withAnimation {
            self.viewModel.addCareActivity(type: .water)
        }
    }
    
    private func deletePlant() {
        withAnimation {
            self.presentationMode.wrappedValue.dismiss()
            self.viewModel.deletePlant()
        }
    }
}

struct PlantDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let model = GrowModel()
        model.addPlant()
        
        let viewModel = PlantDetailViewModel(model: model, plant: model.plants[0])
        
        let view = NavigationView {
            PlantDetailView(viewModel: viewModel)
        }
        
        return Group {
            view
            view.environment(\.colorScheme, .dark)
        }
    }
}
