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
    
    var selectedMultipler: Int {
        let cal = Calendar.current
        return cal.component(.weekday, from: selectedDate)
    }
    
    struct Section<Value: Hashable>: Hashable {
        let id = UUID()
        var values: [Value]
    }
    
    var data: [CompositionalCollectionSection<Int>] {
        return [
            .init(items: [-1], layout: listLayout),
            .init(items: Array(10..<12).map{$0+selectedMultipler}, layout: twoWideGrid),
            .init(items: [20, 21, 22], layout: threeWideGrid),
            .init(items: [30, 31, 32], layout: gridCenterHeavy),
            .init(items: [40, 41, 42], layout: girdLeftHeavy),
        ]
    }
    
    var body: some View {
        CompositionalCollection(sections: data, content: cellContent)
//            .edgesIgnoringSafeArea(.all)
//            .navigationBarTitle("CCV! :)")
    }
    
    func listLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 6, bottom: 6, trailing: 6)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(80)), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
    }
    
    func twoWideGrid() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 3, bottom: 6, trailing: 3)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44)), subitems: [item])
        
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 3)
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    func threeWideGrid() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 3, bottom: 6, trailing: 3)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44)), subitems: [item])
        
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 3)
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    func girdLeftHeavy() -> NSCollectionLayoutSection {
        let itemSmall = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(2/7), heightDimension: .fractionalHeight(1)))
        itemSmall.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 3, bottom: 6, trailing: 3)
        
        let itemLarge = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(3/7), heightDimension: .fractionalHeight(1)))
        itemLarge.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 3, bottom: 6, trailing: 3)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44)), subitems: [itemLarge, itemSmall, itemSmall])
        
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 3)
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    func gridCenterHeavy() -> NSCollectionLayoutSection {
        let itemSmall = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(2/7), heightDimension: .fractionalHeight(1)))
        itemSmall.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 3, bottom: 6, trailing: 3)
        
        let itemLarge = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(3/7), heightDimension: .fractionalHeight(1)))
        itemLarge.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 3, bottom: 6, trailing: 3)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44)), subitems: [itemSmall, itemLarge])
        
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 3)
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    @ViewBuilder func cellContent(indexPath: IndexPath, item: Int) -> some View {
        Group {
            if indexPath.section == 0 {
                WeekCalendarPicker(selectedDate: $selectedDate) { date in
                    VStack {
                        Text("\(Calendar.current.component(.weekday, from: date))")
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            } else {
                Text("\(indexPath.section):\(indexPath.row) - \(item)")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Rectangle().stroke())
            }
        }
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
                    .padding(.top)
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
    }
}
