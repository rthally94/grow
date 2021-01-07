//
//  WeekCalendarViewExtended.swift
//  Grow iOS
//
//  Created by Ryan Thally on 1/4/21.
//  Copyright © 2021 Ryan Thally. All rights reserved.
//

import SwiftUI

struct WeekCalendarViewExtended: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewControllerType {
        let vc = UIViewControllerType()
        
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    typealias UIViewControllerType = WeekCalendarViewController 
    
    
}

struct WeekCalendarViewExtended_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            WeekCalendarViewExtended()
                .border(Color.red)
            Spacer()
        }
    }
}
