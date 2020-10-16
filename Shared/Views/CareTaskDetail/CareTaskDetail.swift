//
//  CareTaskDetail.swift
//  Grow iOS
//
//  Created by Ryan Thally on 8/31/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI

struct CareTaskDetail: View {
    var notesSupportsExpansion: Bool {
        return true
    }
    
    @State var notesIsExpanded: Bool = false
    
    var body: some View {
        List {
            Section {
                HStack {
                    Image(systemName: "flame.fill")
                    Text("Task Type")
                    
                    Spacer()
                }
                
                Text("Plant Name")
            }
            
            Section(header: Text("Interval").font(.headline)) {
                HStack {
                    Text("Last")
                        .frame(maxWidth: .infinity)
                    
                    Divider()
                    
                    Text("Next")
                        .frame(maxWidth: .infinity)
                }
                Text("Do me all the time.")
            }
            
            Section (header: Text("Care Notes").font(.headline) ) {
                if !notesIsExpanded {
                    VStack(alignment: .trailing) {
                        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. In porttitor at tortor et porta. Sed non congue ante, a luctus velit. Cras quis imperdiet risus, mattis fringilla eros. Fusce et leo accumsan augue volutpat gravida. Fusce a ipsum sed libero interdum viverra quis non odio. Duis viverra suscipit consequat. Praesent fermentum fermentum vestibulum. Mauris sed orci posuere, dictum diam sed, placerat eros. Maecenas a sapien eget magna molestie suscipit. In dignissim dolor vitae mi molestie, dapibus sodales lacus egestas. Phasellus ipsum urna, mollis sit amet dapibus in, dictum eget nisi. ")
                            .lineLimit(notesLineLimit)
                        
                        Button("more") {
                            withAnimation {
                                self.notesIsExpanded = true
                            }
                        }
                    }
                } else {
                    Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. In porttitor at tortor et porta. Sed non congue ante, a luctus velit. Cras quis imperdiet risus, mattis fringilla eros. Fusce et leo accumsan augue volutpat gravida. Fusce a ipsum sed libero interdum viverra quis non odio. Duis viverra suscipit consequat. Praesent fermentum fermentum vestibulum. Mauris sed orci posuere, dictum diam sed, placerat eros. Maecenas a sapien eget magna molestie suscipit. In dignissim dolor vitae mi molestie, dapibus sodales lacus egestas. Phasellus ipsum urna, mollis sit amet dapibus in, dictum eget nisi. ")
                }
                
            }
            
            Section(header: logHistoryHeader) {
                ForEach(0..<numberOfVisibleLogs) { index in
                    NavigationLink(destination: Text("fda")) {
                        Text("\(index)")
                    }
                }
            }
        }
        .listStyle(GroupedListStyle())
    }
    
    var logHistoryHeader: some View {
        HStack {
            Text("History").font(.headline)
            Spacer()
            NavigationLink("View All", destination: Text("History"))
        }
    }
    
    // MARK: Constants
    private let notesLineLimit = 3
    private let numberOfVisibleLogs = 4
}

struct CareTaskDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CareTaskDetail()
        }
    }
}
