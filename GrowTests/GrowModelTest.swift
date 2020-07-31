//
//  PlantModelTest.swift
//  GrowFrameworkTests
//
//  Created by Ryan Thally on 7/6/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import Foundation
import XCTest

@testable import Grow_

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
            let plant = Plant(name: "My Plant \(tag)")
            sut.addPlant(plant)
        
            XCTAssertEqual(sut.plants[tag], plant)
        }
    }
    
    func testPlantStore_WhenPlantIsDeleted_PlantIsRemovedFromCollection() {
        let sut = GrowModel()
        let plant = Plant(name: "My Plant")
        
        sut.addPlant(plant)
        sut.deletePlant(plant: plant)
        XCTAssertFalse(sut.plants.contains(plant))
    }
    
    func testPlantStore_WhenPlantIsUpdated_PlantIsUpdatedInCollection() {
        let sut = GrowModel()
        let plant = Plant(name: "My Plant")
        sut.addPlant(plant)
        
        let newName = "Your Plant"
        
        guard let index = sut.plants.firstIndex(of: plant) else {return XCTFail() }
        sut.plants[index].name = newName
        
        XCTAssertEqual(sut.plants[index].name, newName)
    }
    
    func testPlantStore_WhenCareLogIsAdded_PlantIsUpdatedInCollection() {
        let sut = GrowModel()
        sut.addPlant()
            
        XCTAssertEqual(sut.plants[0].careTasks.count, 0)
        
        let task = CareTask()
        sut.addCareTask(task, to: sut.plants[0])
        
        XCTAssertEqual(sut.plants[0].careTasks.count, 1)
    }
}
