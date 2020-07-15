//
//  SunTolerancePickerTableViewController.swift
//  Agronomist
//
//  Created by Ryan Thally on 6/18/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import UIKit

protocol SunTolerancePickerDelegate {
    func didSelect(_ state: SunTolerance)
}

class SunTolerancePickerTableViewController: UITableViewController {
    private let states = SunTolerance.allCases
    var delegate: SunTolerancePickerDelegate?
    private var selectedSunTolerance: SunTolerance = .fullShade
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        
        // Check if going backwards (back pressed)
        if parent == nil {
            delegate?.didSelect(selectedSunTolerance)
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return states.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = states[indexPath.row].name
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSunTolerance = states[indexPath.row]
        navigationController?.popViewController(animated: true)
    }
}
