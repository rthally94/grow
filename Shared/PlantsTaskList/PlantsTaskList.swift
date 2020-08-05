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
    @State var selectedIndex = Set(arrayLiteral: "")
    
    var body: some View {
        ScrollView {
            VStack {
                GrowPicker(Calendar.current.veryShortStandaloneWeekdaySymbols, selection: $selectedIndex) { symbol, isSelected in
                    Text(symbol)
                        .padding()
                        .background(Circle().stroke().scale(isSelected ? 1 : 0))
                }
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
