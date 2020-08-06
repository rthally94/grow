//
//  PlantsTaskList.swift
//  Grow iOS
//
//  Created by Ryan Thally on 7/28/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI

struct PlantsTaskList: View {
    @EnvironmentObject var model: GrowModel
    @State var selectedDay: Int = Calendar.current.component(.weekday, from: Date())-1
    
    var navigationBarTitle: String {
        let date = Calendar.current.date(bySetting: .weekday, value: selectedDay+1, of: Date()) ?? Date()
        return Formatters.relativeDateFormatter.string(for: date)
    }
    
    var body: some View {
        ScrollView {
            VStack {
                WeekPicker(selection: $selectedDay)
                
                Divider()
              
                Grow_TaskCard()
                Grow_TaskCard()
                Grow_TaskCard()
                
            }
            .padding()
        }
    .navigationBarTitle(navigationBarTitle)
    }
}

struct PlantsTaskList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PlantsTaskList()
        }
    }
}
