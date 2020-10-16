//
//  CareTaskLog+Extension.swift
//  Grow iOS
//
//  Created by Ryan Thally on 9/5/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import Foundation

extension CareTaskLogMO {
    var date: Date {
        get { date_ ?? Date() }
        set { date_ = newValue }
    }
}
