//
//  CareTaskTypeMO+Extension.swift
//  Grow iOS
//
//  Created by Ryan Thally on 8/26/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import Foundation
import CoreData
import SwiftUI

extension CareTaskType {
    static func allTypesFetchRequest() -> NSFetchRequest<CareTaskType> {
        let request: NSFetchRequest<CareTaskType> = CareTaskType.fetchRequest()
        request.sortDescriptors = [ NSSortDescriptor(keyPath: \CareTaskType.name_, ascending: true) ]
        return request
    }
    
    static func allBuiltInTypesRequest() -> NSFetchRequest<CareTaskType> {
        let request: NSFetchRequest<CareTaskType> = CareTaskType.fetchRequest()
        request.predicate = NSPredicate(format: "builtIn == YES")
        request.sortDescriptors = [ NSSortDescriptor(keyPath: \CareTaskType.name_, ascending: true)]
        return request
    }
}

extension CareTaskType {
    var name: String {
        get { name_ ?? "" }
        set { name_ = newValue }
    }
    
    var iconImage: ImageLoader? {
        ImageLoader(icon ?? "")
    }
    
    var color: UIColor {
        get {
            UIColor(hexString: color_ ?? "") ?? UIColor.systemBlue
        }
        
        set {
            color_ = newValue.hexString() ?? ""
        }
    }
}

extension CareTaskType {
    enum Section: Int, CaseIterable, CustomStringConvertible {
        case builtIn, user
        
        var description: String {
            switch self {
            case .builtIn: return "Built In"
            case .user: return "User"
            }
        }
    }
}
