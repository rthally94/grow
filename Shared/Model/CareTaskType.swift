//
//  CareTaskType.swift
//  Grow iOS
//
//  Created by Ryan Thally on 8/6/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import Foundation
import UIKit

extension CareTaskType {
    var name: String {
        get { name_ ?? "" }
        set { name_ = newValue }
    }
}

extension CareTaskType: Comparable {
    public static func < (lhs: CareTaskType, rhs: CareTaskType) -> Bool {
        lhs.name < rhs.name
    }
}
