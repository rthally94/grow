////
////  CareTaskType.swift
////  Grow iOS
////
////  Created by Ryan Thally on 8/6/20.
////  Copyright © 2020 Ryan Thally. All rights reserved.
////
//
//import Foundation
//import UIKit
//import CoreData
//
//// MARK: Fetch Requests
//extension CareTaskType {
//    static var AllTaskTypesFetchRequest: NSFetchRequest<CareTaskType> {
//        let request = NSFetchRequest<CareTaskType>()
//        request.entity = CareTaskType.entity()
//        request.sortDescriptors = [ NSSortDescriptor(keyPath: \CareTaskType.name_, ascending: true)]
//        
//        return request
//    }
//}
//
//// MARK: Proptery Wrappers
//extension CareTaskType {
//    var name: String {
//        get { name_ ?? "" }
//        set { name_ = newValue }
//    }
//}
//
//// MARK: Comparable Protocol
//extension CareTaskType: Comparable {
//    public static func < (lhs: CareTaskType, rhs: CareTaskType) -> Bool {
//        lhs.name < rhs.name
//    }
//}
