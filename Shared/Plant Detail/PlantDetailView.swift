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
        VStack(alignment: .leading) {
            title
                .opacity(0.8)
            subtitle.fontWeight(.bold)
        }
    }
    
    init(title: String, subtitle: String) {
        self.init(title: Text(title), subtitle: Text(subtitle))
    }
    
    init(title: Text, subtitle: Text) {
        self.title = title
        self.subtitle = subtitle
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

struct GroupedSection<Header: View, Content: View>: View {
    let header: () -> Header
    var content: () -> Content
    
    var body: some View {
        VStack {
            header()
                .padding(.bottom)
            content()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(.systemGroupedBackground)
        )
    }
}

struct PlantDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    
    // Model State
    @ObservedObject var viewModel: PlantDetailViewModel
    
    // View State
    @State private var plantActionSheetIsPresented = false
    
    // Static Views
    
    private let growingConditionSectionHeader: () -> AnyView = {
        AnyView (
            HStack {
                //                Image(systemName: "scissors")
                Text("Growing Conditions").font(.callout)
                Spacer()
            }
        )
    }
    
    private let recentCareSectionHeader: () -> AnyView = {
        AnyView (
            HStack {
                //                Image(systemName: "heart")
                Text("Recent Care Activity").font(.callout)
                Spacer()
                Button(action: {}, label: {Text("View All")})
            }
        )
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                Text(self.viewModel.ageValue)
                GroupedSection( header: {
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
                        StatCell(title: self.viewModel.plantWateringTitle, subtitle: self.viewModel.plantWateringValue)
                        Spacer()
                    }
                    .animation(.none)
                }
                
                GroupedSection(header: {
                    HStack {
                        Group {
                            Image(systemName: "scissors")
                            Text("Growing Conditions")
                        }
                        .font(.headline)
                        
                        Spacer()
                    }
                }) {
                    VStack(spacing: 10) {
                        HStack {
                            Group {
                                StatCell(title: "Sun Tolerance", subtitle: "No Val")
                                StatCell(title: "Watering", subtitle: self.viewModel.plantWateringValue)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        HStack {
                            Group {
                                StatCell(title: "Fertilizing", subtitle: "No Val")
                                StatCell(title: "Pruning", subtitle: "No Val")
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                
                //                GroupedSection(header: self.recentCareSectionHeader) {
                //                    ForEach(self.viewModel.recentCareActivity) { log in
                //                        ListRow(image: Image(systemName: "scissors"), title: log.type.description, value: Formatters.dateFormatter.string(from: log.date))
                //                    }
                //                }
            }
            .padding(.horizontal)
        }
        .navigationBarTitle(viewModel.name)
        .navigationBarItems(trailing: Button(action: showActionSheet) {
            Image(systemName: "ellipsis.circle")
        })
            .actionSheet(isPresented: $plantActionSheetIsPresented) {
                ActionSheet(title: Text("Plant Options"), buttons: [
                    ActionSheet.Button.default(Text("Log Care Activity"), action: addCareActivity),
                    ActionSheet.Button.default(Text("Edit Plant"), action: {}),
                    ActionSheet.Button.destructive(Text("Delete Plant"), action: deletePlant),
                    ActionSheet.Button.cancel()
                ])
        }
    }
    
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
        
        return view
    }
}
