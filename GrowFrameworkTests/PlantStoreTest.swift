//
//  PlantStoreTest.swift
//  GrowFrameworkTests
//
//  Created by Ryan Thally on 7/6/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import Foundation
import XCTest

@testable import GrowFramework

class PlantStoreTest: XCTestCase {
    func testPlantStore_WhenInitialized_NoPlantsAreStored() {
        let sut = PlantStore()
        XCTAssertEqual(sut.getPlants().count, 0)
    }
    
    func testPlantStore_WhenPlantIsAdded_CountIncreasesByOne() {
        let sut = PlantStore()
        
        for tag in 1...4 {
            sut.addPlant()
            XCTAssertEqual(sut.getPlants().count, tag)
        }
    }
    
    func testPlantStore_WhenPlantIsAdded_AddedPlantIsInCollection() {
        let sut = PlantStore()
        
        for tag in 0..<4 {
            let name = "My Plant \(tag)"
            sut.addPlant(name: name)
        
            XCTAssertEqual(sut.getPlant(at: tag)!.name, name)
        }
    }
    
    func testPlantStore_WhenPlantIsDeleted_PlantIsRemovedFromCollection() {
        let sut = PlantStore()
        let plantName = "My Plant"
        sut.addPlant(name: plantName)
        let plant = sut.getPlant(at: 0)
        
        sut.deletePlant(plant: plant!)
        XCTAssertFalse(sut.getPlants().contains(plant!))
    }
    
    func testPlantStore_WhenPlantIsUpdated_PlantIsUpdatedInCollection() {
        let sut = PlantStore()
        let name = "My Plant"
        sut.addPlant(name: name)
        
        let plant = sut.getPlant(at: 0)
        
        let newName = "Your Plant"
        sut.updatePlant(plant!, name: newName)
        XCTAssertEqual(sut.getPlant(at: 0)!.name, newName)
    }
}
