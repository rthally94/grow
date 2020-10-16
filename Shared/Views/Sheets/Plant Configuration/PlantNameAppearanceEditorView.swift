//
//  PlantNameAppearanceEditorView.swift
//  Grow iOS
//
//  Created by Ryan Thally on 10/13/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI
import CoreData

struct PlantNameAppearanceEditorView: View {
    @EnvironmentObject var growModel: GrowModel
    @Environment(\.managedObjectContext) var viewContext
    
    @ObservedObject var plant: Plant
    
    static let systemImages = [
        "plant.cactus1.fill",
        "plant.cactus2.fill",
        "plant.rubber.fill",
        "plant.snake.fill",
        "plant.succulent.fill",
        "plant.sunflower.fill",
        "plant.yucca.fill",
        
        "plant.cactus1.pot.fill",
        "plant.cactus2.pot.fill",
        "plant.rubber.pot.fill",
        "plant.snake.pot.fill",
        "plant.succulent.pot.fill",
        "plant.sunflower.pot.fill",
        "plant.yucca.pot.fill",
    ]
    
    static let systemColors = [
        UIColor(named: "Brink Pink")?.cgColor,
        UIColor(named: "Carolina Blue")?.cgColor,
        UIColor(named: "Emerald")?.cgColor,
        UIColor(named: "Jazzberry Jam")?.cgColor,
        UIColor(named: "Minion Yellow")?.cgColor,
        UIColor(named: "Ruby Red")?.cgColor,
        UIColor(named: "Spanish Veridian")?.cgColor,
        UIColor(named: "St Patricks Blue")?.cgColor,
        UIColor(named: "Tangerine")?.cgColor,
    ]
    
    @State var colorChoice: CGColor
    @State var imageChoice: Int
    
    init(plant: Plant) {
        self.plant = plant
        
        _colorChoice = State(initialValue: plant.tintColor.cgColor)
        if let iconName = plant.icon_, let iconIndex = PlantNameAppearanceEditorView.systemImages.firstIndex(of: iconName) {
            _imageChoice =  State(initialValue: iconIndex)
        } else {
            _imageChoice = State(initialValue: 0)
        }
    }
    
    var body: some View {
        VStack(spacing: 40) {
            Section {
                ZStack {
                    Color(colorChoice)
                    Image(PlantNameAppearanceEditorView.systemImages[imageChoice])
                        .resizable()
                        .scaledToFit()
                        .padding(8)
                        .foregroundColor(.white)
                }
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .aspectRatio(1, contentMode: .fit)
                .frame(maxHeight: 100)
            }
            
            Section {
                TextField("Name", text: $plant.name)
                    .multilineTextAlignment(.center)
                    .font(.headline)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(spacing: 8), count: 6)) {
                    Section {
                        ForEach(PlantNameAppearanceEditorView.systemColors, id: \.self) { color in
                            if let color = color {
                                Button( action: { colorChoice = color }, label: {
                                    Color(color)
                                        .aspectRatio(contentMode: .fit)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .padding(2)
                                        .background(RoundedRectangle(cornerRadius: 10).stroke().foregroundColor(.gray).opacity(colorChoice == color ? 1.0 : 0.0))
                                        .padding(2)
                                })
                            }
                        }
                    }
                    
                    Section {
                        ForEach(PlantNameAppearanceEditorView.systemImages, id: \.self) { imageName in
                            Button(action: { imageChoice = PlantNameAppearanceEditorView.systemImages.firstIndex(of: imageName) ?? 0 }, label: {
                                ZStack {
                                    Color.gray
                                    Image(imageName)
                                        .resizable()
                                        .scaledToFit()
                                        .padding(8)
                                        .foregroundColor(.white)
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding(2)
                                .background(RoundedRectangle(cornerRadius: 10).stroke().foregroundColor(.gray).opacity(PlantNameAppearanceEditorView.systemImages[imageChoice] == imageName ? 1.0 : 0.0))
                                .padding(2)
                            })
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.top)
        .navigationBarTitle("Name and Appearance", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    viewContext.rollback()
                    growModel.sheetToPresent = nil
                }
            }
            
            ToolbarItem {
                Button("Save") {
                    plant.icon_ = PlantNameAppearanceEditorView.systemImages[imageChoice]
                    plant.tintColor = UIColor(cgColor: colorChoice)
                    
                    try? viewContext.save()
                    growModel.sheetToPresent = nil
                }
                .disabled(plant.name == "")
            }
        }
    }
}

struct PlantNameAppearanceEditorView_Previews: PreviewProvider {
    static var previews: some View {
        let persistence = PersistenceController.preview
        
        let request: NSFetchRequest<Plant> = Plant.allPlantsFetchRequest()
        request.fetchLimit = 1
        
        let plant = try? persistence.container.viewContext.fetch(request).first
        
        return
            NavigationView {
                PlantNameAppearanceEditorView(plant: plant!)
            }
            .environmentObject(GrowModel())
    }
}
