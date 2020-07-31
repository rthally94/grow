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
    @State var selectedDate = Date()
    
    var plantsNeedingCare: [Section: [content]] {
        var data: [Section: [content]] = [:]
        for section in Section.allCases {
            switch section {
            case .weekPicker:
                data[section] = Array(0..<8).map { content(section: section, value: $0)}
            case .needsCare:
                data[section] = Array(0..<8).map { content(section: section, value: $0*2)}
            }
        }
        return data
    }
    
    enum Section: Int, CaseIterable, Comparable, CustomStringConvertible {
        static func < (lhs: PlantsTaskList.Section, rhs: PlantsTaskList.Section) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }
        
        case weekPicker
        case needsCare
        
        var description: String {
            switch self {
            case .weekPicker: return "Week Picker"
            case .needsCare: return "Needs Care"
            }
        }
    }
    
    struct content: Hashable {
        var section: Section
        var value: Int
    }
    
    var body: some View {
        UICollectionViewWrapper(data: plantsNeedingCare, boundarySupplementaryItem: collectionViewSectionHeader, content: collectionViewContent)
            .edgesIgnoringSafeArea(.all)
            .navigationBarTitle("Care Tasks")
    }
    
    @ViewBuilder func collectionViewSectionHeader(_ section: Section, _ kind: String) -> some View {
        HStack {
            Text("\(section.description)").font(.title)
            Spacer()
        }
    }
    
    @ViewBuilder func collectionViewContent(_ item: content) -> some View {
        HStack(alignment: .lastTextBaseline) {
            Image(systemName: "person.crop.circle").imageScale(.large)
            Text("\(item.value)")
            Spacer()
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 15).stroke())
    }
}

struct PlantsTaskList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PlantsTaskList()
        }
    }
}

struct WeekCalendarPicker<Content: View>: View {
    @Binding var selectedDate: Date
    var content: (Date) -> Content
    
    let calendar = Calendar.current
    
    var start: Date {
        selectedDate.startOfWeek ?? Date()
    }
    
    func nextDate(offset: Int) -> Date {
        let next = calendar.date(byAdding: .weekday, value: offset, to: start) ?? start
        return next
    }
    
    var selectedWeekdayIndex: Int {
        calendar.component(.weekday, from: selectedDate) - 1
    }
    
    var count: Int {
        calendar.veryShortStandaloneWeekdaySymbols.count
    }
    
    func cellColor(for date: Date) -> Color {
        calendar.isDateInToday(date) ? Color.green : Color.gray
    }
    
    var body: some View {
        HStack {
            ForEach(0..<count) { index in
                Spacer()
                
                VStack {
                    Group {
                        if self.selectedWeekdayIndex == index {
                            Image(systemName: "\(self.calendar.veryShortStandaloneWeekdaySymbols[index].lowercased()).square.fill")
                                .font(.system(size: 24))
                                .transition(.asymmetric(insertion: .scale, removal: .identity))
                            
                        } else {
                            Text(self.calendar.veryShortStandaloneWeekdaySymbols[index])
                                .font(.system(size: 18))
                                .transition(.identity)
                        }
                    }
                    .foregroundColor(self.cellColor(for: self.nextDate(offset: index)))
                    
                    Spacer()
                    
                    self.content(self.nextDate(offset: index))
                }
                .onTapGesture {
                    withAnimation {
                        self.selectedDate = self.nextDate(offset: index)
                    }
                }
                
            }
            Spacer()
        }
        .padding(.vertical)
    }
}
