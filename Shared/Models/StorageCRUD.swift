//
//  StorageCRUD.swift
//  Grow iOS
//
//  Created by Ryan Thally on 8/25/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import Foundation

protocol StorageCRUD {
    associatedtype Item
    @discardableResult func create() -> Item
    func delete(_ item: Item)
}
