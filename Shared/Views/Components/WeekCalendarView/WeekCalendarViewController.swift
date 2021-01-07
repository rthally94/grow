//
//  WeekCalendarViewController.swift
//  Grow iOS
//
//  Created by Ryan Thally on 1/4/21.
//  Copyright © 2021 Ryan Thally. All rights reserved.
//

import UIKit
import Combine

private let weekLabelReuseIdentifier = "WeekLabelCell"
private let weekDateReuseIdentifier = "WeekDateCell"

class WeekCalendarViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    // Calendar constraints
    var lowerBound: Date {
        guard let start = Calendar.current.nextWeekend(startingAfter: Date(timeIntervalSince1970: 0), direction: .backward)?.start else { return Date() }
        return Calendar.current.date(byAdding: .day, value: 1, to: start) ?? Date()
    }
    
    var upperBound: Date {
        Calendar.current.date(byAdding: DateComponents(year: 100), to: lowerBound)!
    }
    
    var numberOfDays: Int {
        return Calendar.current.dateComponents([.day], from: lowerBound, to: upperBound).day ?? 0
    }
    
    // Calendar state
    private let scrollviewOffset = PassthroughSubject<CGFloat, Never>()
    private var scrollviewOffsetSubscription: AnyCancellable?
    private func weekPickerDidScroll(visibleItems: [NSCollectionLayoutVisibleItem], point: CGPoint, env: NSCollectionLayoutEnvironment) {
        let pageWidth = env.container.effectiveContentSize.width
        let page = (point.x + pageWidth / 2) / pageWidth
        self.scrollviewOffset.send(page)
    }
    
    var selectedDate = Date(timeIntervalSince1970: 0)
    
    var currentPage: Int {
        let selectedDateIndex = index(for: selectedDate)
        return selectedDateIndex.item / 7
    }
    
    var currentWeekday: Int {
        Calendar.current.component(.weekday, from: selectedDate)
    }
    
    func index(for date: Date) -> IndexPath {
        IndexPath(item: Calendar.current.dateComponents([.day], from: lowerBound, to: date).day ?? 0, section: 1)
    }
    
    func date(for index: IndexPath) -> Date {
        Calendar.current.date(byAdding: .day, value: index.item, to: lowerBound) ?? Date()
    }
    
    private func weekCalendarLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 0...1:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/7), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(30))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = sectionIndex == 1 ? .paging : .none
                
                if sectionIndex == 1 {
                    section.visibleItemsInvalidationHandler = self.weekPickerDidScroll(visibleItems:point:env:)
                }
                
                return section
            
            default:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                return section
            }
        }
    }
    
    private var collectionView: UICollectionView!
    
    private let compactDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()
    
    private let longDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        return formatter
    }()
    
    // MARK:- Intents
    private func selectDate(at indexPath: IndexPath, animated: Bool = true) {
        let newDate = date(for: indexPath)
        guard newDate >= lowerBound && newDate < upperBound else { return }
        
        let oldIndex = index(for: selectedDate)
        let newIndex = indexPath
        
        self.selectedDate = newDate
        
        collectionView.performBatchUpdates {
            self.collectionView.reloadSections([2])
            self.collectionView.deselectItem(at: oldIndex, animated: animated)
            self.collectionView.selectItem(at: newIndex, animated: animated, scrollPosition: .centeredHorizontally)
        }
    }
    
    private func previousWeek() {
        guard let newDate = Calendar.current.date(byAdding: .weekdayOrdinal, value: -1, to: selectedDate) else { return }
        let newIndex = index(for: newDate)
        self.collectionView(self.collectionView, didSelectItemAt: newIndex)
    }
    
    private func nextWeek() {
        guard let newDate = Calendar.current.date(byAdding: .weekdayOrdinal, value: 1, to: selectedDate) else { return }
        let newIndex = index(for: newDate)
        self.collectionView(self.collectionView, didSelectItemAt: newIndex)
    }
    
    // MARK:- View Lifecycle
    
    override func loadView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: weekCalendarLayout())
        self.view = collectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.backgroundColor = .systemBackground
        
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        
        // Register cell classes
        self.collectionView.register(WeekDateCell.self, forCellWithReuseIdentifier: weekDateReuseIdentifier)
        self.collectionView.register(WeekLabelCell.self, forCellWithReuseIdentifier: weekLabelReuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        scrollviewOffsetSubscription = scrollviewOffset
            .debounce(for: 0.1, scheduler: RunLoop.main)
            .map {
                return Int(floor($0))
            }
            .sink {
                if self.currentPage > $0 {
                    self.previousWeek()
                } else if self.currentPage < $0 {
                    self.nextWeek()
                }
            }
        
        let indexOfToday = index(for: Date())
        self.selectDate(at: indexOfToday, animated: false)
        self.collectionView(self.collectionView, didSelectItemAt: indexOfToday)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        scrollviewOffsetSubscription?.cancel()
    }
    
    // MARK:- UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return 7
        case 1: return numberOfDays
        case 2: return 1
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: weekLabelReuseIdentifier, for: indexPath) as? WeekLabelCell else { fatalError("Week Cell not available for reuse!")}
            cell.textLabel.text = Calendar.current.veryShortStandaloneWeekdaySymbols[indexPath.item % 7]
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: weekDateReuseIdentifier, for: indexPath) as? WeekDateCell else { fatalError("Week Cell not available for reuse!")}
            guard let date = Calendar.current.date(byAdding: .day, value: indexPath.item, to: lowerBound) else { fatalError("Invalid date for cell")}
            cell.textLabel.text = compactDateFormatter.string(from: date)
            return cell
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: weekLabelReuseIdentifier, for: indexPath) as? WeekLabelCell else { fatalError("Week Cell not available for reuse!")}
            cell.textLabel.text = longDateFormatter.string(from: selectedDate)
            return cell
        default:
            fatalError("Unknown section for week calendar view: \(indexPath.section)")
        }
    }
    
    // MARK:- CollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectDate(at: indexPath)
        
        // Configure cell for selection
        if let cell = collectionView.cellForItem(at: indexPath) as? WeekDateCell {
            cell.showSelection()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        // Configure cell for deselection
        if let cell = collectionView.cellForItem(at: indexPath) as? WeekDateCell {
            cell.hideSelection()
        }
    }
}
