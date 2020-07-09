//
//  PlantModelTest.swift
//  GrowFrameworkTests
//
//  Created by Ryan Thally on 7/6/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import Foundation
import XCTest

@testable import Grow_iOS

class GrowModelTest: XCTestCase {
    func testPlantStore_WhenInitialized_NoPlantsAreStored() {
        let sut = GrowModel()
        XCTAssertEqual(sut.plants.count, 0)
    }
    
    func testPlantStore_WhenPlantIsAdded_CountIncreasesByOne() {
        let sut = GrowModel()
        
        for tag in 1...4 {
            sut.addPlant()
            XCTAssertEqual(sut.plants.count, tag)
        }
    }
    
    func testPlantStore_WhenPlantIsAdded_AddedPlantIsInCollection() {
        let sut = GrowModel()
        
        for tag in 0..<4 {
            let name = "My Plant \(tag)"
            sut.addPlant(name: name)
        
            XCTAssertEqual(sut.plants[tag].name, name)
        }
    }
    
    func testPlantStore_WhenPlantIsDeleted_PlantIsRemovedFromCollection() {
        let sut = GrowModel()
        let plantName = "My Plant"
        sut.addPlant(name: plantName)
        let plant = sut.plants[0]
        
        sut.deletePlant(plant: plant)
        XCTAssertFalse(sut.plants.contains(plant))
    }
    
    func testPlantStore_WhenPlantIsUpdated_PlantIsUpdatedInCollection() {
        let sut = GrowModel()
        let name = "My Plant"
        sut.addPlant(name: name)
        
        let plant = sut.plants[0]
        
        let newName = "Your Plant"
        sut.updatePlant(plant, name: newName)
        XCTAssertEqual(sut.plants[0].name, newName)
    }
}
