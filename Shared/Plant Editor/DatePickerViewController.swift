//
//  DatePickerViewController.swift
//  Agronomist
//
//  Created by Ryan Thally on 6/30/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import UIKit

protocol DatePickerDelegate: class {
    func didSelect(_ interval: CareInterval)
}

class DatePickerViewController: UIViewController {
    weak var delegate: DatePickerDelegate?
    private var tableView = UITableView()
    
    // MARK: Date Picker Properties
    private var interval = CareInterval() {
        didSet {
            print("Set!", interval.description)
        }
    }
    
    // MARK: Table View Cells
    private let weekPickerCell: WeekPickerCell = {
        let cell = WeekPickerCell()
        
        for tag in 0..<7 {
            let day = Formatters.shortDayOfWeek(for: tag)?.lowercased()
            cell.addSegment(with: "\(tag)", defaultImage: UIImage(systemName: "\(day ?? "").circle"), selectedImage: UIImage(systemName: "\(day ?? "").circle.fill"))
        }
        
        return cell
    }()
    private let monthPickerCell: MonthPickerCell = {
        let cell = MonthPickerCell()
        
        return cell
    }()
    
    override func loadView() {
        super.loadView()
        
        configureHiearchy()
        configureStaticCells()
    }
    
    private func configureHiearchy() {
        tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(WeekPickerCell.self, forCellReuseIdentifier: WeekPickerCell.reuseIdentifier)
        
        view.addSubview(tableView)
    }
    
    private func configureStaticCells() {
        weekPickerCell.delegate = self
        monthPickerCell.delegate = self
    }
    
    private func configureNavigation() {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .top)
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        
        // Going backwards (back button pressed)
        if parent == nil {
            delegate?.didSelect(interval)
        }
    }
}

extension DatePickerViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section, interval.unit) {
        case (0, _): return Interval.Unit.allCases.count
        case (1, .daily): return 0
        case (1, .weekly): return 1
        case (1, .monthly): return 1
            
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch (section, interval.unit) {
        case (0, _): return "Repeats"
        case (1, .monthly): return "Starting"
        
        default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch (section, interval) {
        case (0, let choice) where choice.unit == .daily:
            return repeatIntervalText(for: choice)
        case (1, let choice) where choice.unit != .daily:
            return repeatIntervalText(for: choice)
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section, indexPath.row, interval.unit) {
        case (0, let row, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: "selectionCell") ?? UITableViewCell(style: .default, reuseIdentifier: "selectionCell")
            let repeatValue = Interval.Unit(rawValue: row)
            cell.textLabel?.text = repeatValue?.description.capitalized
            
            let selectedImage = UIImage(systemName: "checkmark")
            cell.accessoryView = UIImageView(image: selectedImage)
            cell.accessoryView?.isHidden = repeatValue != interval.unit
            
            return cell
            
        case (1, _, .weekly):
            weekPickerCell.reload()
            return weekPickerCell
            
        case (1, _, .monthly):
            monthPickerCell.reload()
            return monthPickerCell
            
        default:
            return tableView.dequeueReusableCell(withIdentifier: "selectionCell") ?? UITableViewCell(style: .default, reuseIdentifier: "selectionCell")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section, interval.unit) {
        case (1, .monthly):
            return 256.0
            
        default:
            return UITableView.automaticDimension
        }
    }
}

extension DatePickerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (0, let row):
            let previousRepeatChoice = interval
            let newUnit = Interval.Unit(rawValue: row) ?? .daily
            
            if previousRepeatChoice.unit != newUnit {
                interval = CareInterval(unit: newUnit, interval: row)
            }
            
            let cell = tableView.cellForRow(at: indexPath)
            cell?.accessoryView?.isHidden = false
            
            tableView.performBatchUpdates({
                switch(previousRepeatChoice.unit, interval.unit) {
                case let (prev, next) where prev == next:
                    return
                    
                default:
                    tableView.reloadSections(IndexSet(arrayLiteral: 0, 1), with: .automatic)
                }
            })
            
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryView?.isHidden = true
    }
}

extension DatePickerViewController: WeekPickerDelegate {
    func didSelect(_ choices: [Int]) {
        interval.values = choices
        
        tableView.footerView(forSection: 1)?.textLabel?.text = repeatIntervalText(for: interval)
        reloadFooter()
    }
}

extension DatePickerViewController: MonthPickerDelegate {
    func didSelect(_ date: Date) {
        let cal = Calendar.current
        let day = cal.component(.day, from: date)
        interval.values = [day]
        
        tableView.footerView(forSection: 1)?.textLabel?.text = repeatIntervalText(for: interval)
        reloadFooter()
    }
}

// MARK: Helpers
extension DatePickerViewController {
    private func reloadFooter() {
        tableView.footerView(forSection: 1)?.setNeedsLayout()
    }
    
    private func repeatIntervalText(for choice: Interval) -> String? {
        let title = self.title ?? "Event"
        
        switch (choice.unit) {
        case .daily: return "\(title) will occur daily."
        case .weekly:
            return "\(title) will occur \(choice.description)"
        case .monthly: return "\(title) will occur \(choice.description)"
        }
    }
}

fileprivate protocol WeekPickerDelegate: class {
    func didSelect(_ choices: [Int])
}

fileprivate class WeekPickerCell: UITableViewCell {
    static let reuseIdentifier = "WeekPickerCell"
    weak var delegate: WeekPickerDelegate?
    private var selection = Set<Int>()
    
    func addSegment(with title: String?, defaultImage: UIImage? = nil, selectedImage: UIImage? = nil) {
        insertSegment(with: title, defaultImage: defaultImage, selectedImage: selectedImage, at: numberOfSegments)
    }
    
    func insertSegment(with title: String?, defaultImage: UIImage? = nil, selectedImage: UIImage? = nil, at index: Int) {
        let button = UIButton(type: .custom)
        
        let symbolConfig = UIImage.SymbolConfiguration(scale: .large)
        button.setPreferredSymbolConfiguration(symbolConfig, forImageIn: .normal)
        button.setPreferredSymbolConfiguration(symbolConfig, forImageIn: .selected)
        
        button.setImage(defaultImage, for: .normal)
        button.setImage(selectedImage ?? defaultImage, for: .selected)
        
        button.addTarget(self, action: #selector(weekButtonDidPress(sender:)), for: .touchUpInside)
        button.tag = numberOfSegments
        
        weekStack.insertArrangedSubview(button, at: index)
    }
    
    var numberOfSegments: Int {
        return weekStack.arrangedSubviews.count
    }
    
    func reload() {
        if selection.count == 0 {
            if let button = weekStack.arrangedSubviews.first as? UIButton {
                selection.insert(0)
                button.isSelected = true
            }
        }
        
        delegate?.didSelect(Array(selection).sorted())
    }
    
    private let weekStack: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .equalCentering
        return stack
    }()
    
    // MARK: View Lifecycle
    
    
    override func layoutSubviews() {
        configureHiearchy()
        super.layoutSubviews()
    }
    
    private func configureHiearchy() {
        weekStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(weekStack)
        
        NSLayoutConstraint.activate([
            weekStack.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            weekStack.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            weekStack.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            weekStack.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])
    }
    
    @objc
    private func weekButtonDidPress(sender: UIButton) {
        let newIndex = sender.tag
        
        // Force an item to be selected
        if selection.count == 1 && selection.contains(newIndex) {
            return
        }
        
        sender.isSelected.toggle()
        if sender.isSelected {
            selection.insert(newIndex)
        } else {
            selection.remove(newIndex)
        }
        
        delegate?.didSelect(Array(selection).sorted())
    }
    
}

fileprivate protocol MonthPickerDelegate: class {
    func didSelect(_ date: Date)
}

fileprivate class MonthPickerCell: UITableViewCell {
    static let reuseIdentifier = "MonthPickerCell"
    weak var delegate: MonthPickerDelegate?
    
    private var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.minimumDate = Date()
        picker.datePickerMode = .date
        return picker
    }()
    
    func reload() {
        delegate?.didSelect(datePicker.date)
    }
    
    // MARK: View Lifecycle
    override func layoutSubviews() {
        configureHiearchy()
        super.layoutSubviews()
        
        datePicker.addTarget(self, action: #selector(datePickerDidChange(sender:)), for: .valueChanged)
    }
    
    private func configureHiearchy() {
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(datePicker)
        
        NSLayoutConstraint.activate([
            datePicker.heightAnchor.constraint(equalToConstant: 256),
            datePicker.widthAnchor.constraint(equalTo: contentView.layoutMarginsGuide.widthAnchor),
            datePicker.centerYAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerYAnchor),
            datePicker.centerXAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerXAnchor)
        ])
    }
    
    @objc
    private func datePickerDidChange(sender: UIDatePicker) {
        delegate?.didSelect(sender.date)
    }
}
