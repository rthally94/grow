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
    @State var selectedIndex: Int = Calendar.current.component(.weekday, from: Date()) - 1
    
    var body: some View {
        ScrollView {
            VStack {
                SegmentedPicker(items: Calendar.current.veryShortStandaloneWeekdaySymbols, selection: $selectedIndex)
                
                Divider()
              
                Grow_TaskCard()
                Grow_TaskCard()
                Grow_TaskCard()
                
            }
            .padding()
        }
    .navigationBarTitle("Tasks")
    }
}

struct PlantsTaskList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PlantsTaskList()
        }
    }
}
