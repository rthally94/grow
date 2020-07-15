//
//  PlantEditorFormTableViewController.swift
//  Agronomist
//
//  Created by Ryan Thally on 6/17/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import UIKit

protocol PlantEditorFormDelegate {
    func didSave(_ plant: Plant?)
}

enum PlantFormSection: Hashable, CaseIterable {
    case General
    case GrowingConditions
}

struct PlantFormRow: Hashable {
    var value: String
}

class PlantEditorFormTableViewController: UITableViewController {
    enum Section: Int, CaseIterable, CustomStringConvertible {
        case general, growingConditions
        
        var description: String {
            switch self {
            case .general: return "General"
            case .growingConditions: return "Growing Conditions"
            }
        }
    }
    
    let sectionRowHeaders: [Section: [String]] = [
        .general: ["Name"],
        .growingConditions: ["Sun Tolerance", "Watering Frequency"]
    ]
    
    enum FormStyle {
        case new, editing
    }
    
    // MARK: Plant Properties
    var delegate: PlantEditorFormDelegate?
    var plant: Plant?
    var type: FormStyle = .new {
        didSet {
            if type == .new {
                plant = Plant()
            }
        }
    }
    
    // MARK: View Lifecycle
    
    override func loadView() {
        super.loadView()
        
        configureNavigation()
        configureTableView()
    }
    
    // MARK: Configuration
    private func configureNavigation() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissView))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(savePlant))
        navigationItem.title = type == .new ? "New Plant" : "Edit Plant"
    }
    
    private func configureTableView() {
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(TextFieldCell.self, forCellReuseIdentifier: TextFieldCell.reuseIdentifier)
    }
    
    // MARK: Actions
    
    @objc
    private func dismissView() {
        self.dismiss(animated: true, completion: {})
    }
    
    @objc
    private func savePlant() {
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TextFieldCell {
            cell.textFieldShouldResignFirstResponder()
        }
        
        delegate?.didSave(plant)
        self.dismiss(animated: true, completion: {})
    }
    
    // MARK: - Table View Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionKind = Section(rawValue: section) else { return 0 }
        return sectionRowHeaders[sectionKind]?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionKind = Section(rawValue: indexPath.section) else { fatalError("Invalid section") }
        switch (sectionKind, indexPath.row) {
        case (.general, let row):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.reuseIdentifier, for: indexPath) as? TextFieldCell else { fatalError("Unable to dequeue TextFieldCell for reuse") }
            cell.fieldPlaceholder = sectionRowHeaders[.general]?[row]
            cell.fieldText = plant?.name
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
            
        case(.growingConditions, 0):
            let cell = tableView.dequeueReusableCell(withIdentifier: "navigationCell") ?? UITableViewCell(style: .value1, reuseIdentifier: "navigationCell")
            
            cell.textLabel?.text = sectionRowHeaders[.growingConditions]?[0]
            cell.detailTextLabel?.text = plant?.sunTolerance?.name
            cell.accessoryType = .disclosureIndicator
            
            return cell
            
        case(.growingConditions, 1):
            let cell = tableView.dequeueReusableCell(withIdentifier: "navigationCell") ?? UITableViewCell(style: .value1, reuseIdentifier: "navigationCell")
            cell.textLabel?.text = sectionRowHeaders[.growingConditions]?[1]
            cell.detailTextLabel?.text = "\(plant?.wateringInterval?.description.capitalized ?? "")"
            cell.accessoryType = .disclosureIndicator
            return cell
            
        default:
            fatalError("Invalid indexPath for table view")
        }
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        guard let sectionKind = Section(rawValue: indexPath.section) else { return }
        switch (sectionKind, indexPath.row) {
        case(.growingConditions, 0):
            let vc = SunTolerancePickerTableViewController()
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
            
        case(.growingConditions, 1):
            let vc = DatePickerViewController()
            vc.delegate = self
            vc.title = "Watering"
            
            navigationController?.pushViewController(vc, animated: true)
            
        default:
            return
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionKind = Section(rawValue: section) else { return nil }
        return sectionKind.description
    }
}

extension PlantEditorFormTableViewController: TextFieldCellDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        plant?.name = textField.text ?? "NO NAME"
    }
}

extension PlantEditorFormTableViewController: SunTolerancePickerDelegate {
    func didSelect(_ sunTolerance: SunTolerance) {
        plant?.sunTolerance = sunTolerance
        
        let indexPath = IndexPath(item: 0, section: 1)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}

extension PlantEditorFormTableViewController: DatePickerDelegate {
    func didSelect(_ interval: CareInterval) {
        plant?.wateringInterval = interval
        
        let indexPath = IndexPath(item: 1, section: 1)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}
