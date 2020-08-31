//
//  PlantsTaskList.swift
//  Grow iOS
//
//  Created by Ryan Thally on 7/28/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI

struct PlantsTaskList: View {
    @EnvironmentObject var growModel: GrowModel
    @State var selectedDay: Int = Calendar.current.component(.weekday, from: Date())-1
    
    var selectedDayBinding: Binding<Int> {
        Binding<Int>(
            get: { self.selectedDay },
            set: {
                self.selectedDay = $0
                self.growModel.careTaskStorage.getTasks(for: self.dateForSelectedDay())
        })
    }
    
    func dateForSelectedDay() -> Date {
        Calendar.current.date(bySetting: .weekday, value: selectedDay+1, of: Date()) ?? Date()
    }
    
    var navigationBarTitle: String {
        let date = dateForSelectedDay()
        return Formatters.relativeDateFormatter.string(for: date)
    }
    
    var sections: [CareTaskTypeMO: [CareTaskMO] ] {
        Dictionary(grouping: growModel.careTaskStorage.tasks, by: { $0.type } )
    }
    
    var body: some View {
        ScrollView {
            VStack {
                WeekPicker(selection: selectedDayBinding)
                
                Divider()
                
                ForEach( [CareTaskTypeMO](sections.keys), id: \.id) { key in
                    self.sections[key].map {
                        GrowTaskCard(careTasks: $0 )
                        .padding(.vertical)
                    }
                }
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
