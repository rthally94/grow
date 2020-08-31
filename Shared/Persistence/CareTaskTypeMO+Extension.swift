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

extension CareTaskTypeMO {
    static func allTypesFetchRequest() -> NSFetchRequest<CareTaskTypeMO> {
        let request: NSFetchRequest<CareTaskTypeMO> = CareTaskTypeMO.fetchRequest()
        request.sortDescriptors = [ NSSortDescriptor(keyPath: \CareTaskTypeMO.name_, ascending: true) ]
        return request
    }
    
    static func allBuiltInTypesRequest() -> NSFetchRequest<CareTaskTypeMO> {
        let request: NSFetchRequest<CareTaskTypeMO> = CareTaskTypeMO.fetchRequest()
        request.predicate = NSPredicate(format: "builtIn == YES")
        request.sortDescriptors = [ NSSortDescriptor(keyPath: \CareTaskTypeMO.name_, ascending: true)]
        return request
    }
}

extension CareTaskTypeMO {
    var name: String {
        get { name_ ?? "" }
        set { name_ = newValue }
    }
    
    var iconImage: ImageLoader? {
        ImageLoader(icon ?? "")
    }
}

extension CareTaskTypeMO {
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
