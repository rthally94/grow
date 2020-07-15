//
//  PlantEditor.swift
//  Grow iOS
//
//  Created by Ryan Thally on 7/14/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import Foundation
import SwiftUI

struct PlantForm: UIViewControllerRepresentable {
    class Coordinator: PlantEditorFormDelegate {
        func didSave(_ plant: Plant?) {
            print(" Saved ")
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func makeUIViewController(context: Context) -> PlantEditorFormTableViewController {
        let vc = PlantEditorFormTableViewController()
        vc.delegate = context.coordinator
        return vc
    }
    
    func updateUIViewController(_ uiViewController: PlantEditorFormTableViewController, context: Context) {
        
    }
    
    typealias UIViewControllerType = PlantEditorFormTableViewController
}

