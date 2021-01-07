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
        guard let start = Calendar.current.nextWeekend(startingAfter: Date(timeIntervalSince1970: 0), direction: .forward)?.start else { return Date() }
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
    
    var currentPage: Int = 0
    var selectedDate = Date(timeIntervalSince1970: 0)
    
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
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(30))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = sectionIndex == 1 ? .paging : .none
                
                if sectionIndex == 1 {
                    section.visibleItemsInvalidationHandler = { (visibleItems, point, env) in
                        let pageWidth = env.container.effectiveContentSize.width
                        let page = (point.x + pageWidth / 2) / pageWidth
                        self.scrollviewOffset.send(page)
                    }
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
    private func selectDate(at index: IndexPath) {
        let components = DateComponents(day: index.item)
        guard let newDate = Calendar.current.date(byAdding: components, to: lowerBound) else { return }
        
        selectedDate = newDate
        currentPage = index.item / 7
        collectionView.reloadItems(at: [IndexPath(item: 0, section: 2)])
    }
    
    private func selectDate(on page: Int) {
        guard page != currentPage else { return }
        let currentIndex = self.index(for: self.selectedDate)
        let newIndex: IndexPath
        
        if page < currentPage {
            newIndex = IndexPath(item: currentIndex.item - 7, section: 1)
            guard newIndex.item >= 0 else { return }
        } else if page > self.currentPage {
            newIndex = IndexPath(item: currentIndex.item + 7, section: 1)
            guard newIndex.item < self.numberOfDays else { return }
        } else {
            return
        }
        
        self.selectDate(at: newIndex)
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
                self.selectDate(on: $0)
            }
            
        
        selectDate(at: index(for: Date()))
        collectionView.scrollToItem(at: index(for: selectedDate), at: .left, animated: false)
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
            cell.backgroundColor = .red
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        // Configure cell for deselection
        if let cell = collectionView.cellForItem(at: indexPath) as? WeekDateCell {
            cell.backgroundColor = .clear
        }
    }
}

class WeekLabelCell: UICollectionViewCell {
    let textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(textLabel)
        
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            textLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            textLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class WeekDateCell: UICollectionViewCell {
    let textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let selectionImage: UIImageView = {
        let imageView = UIImageView()
        
        let circleImageConfiguration = UIImage.SymbolConfiguration(scale: .large)
        let circleImage = UIImage(systemName: "circle.fill", withConfiguration: circleImageConfiguration)
        imageView.image = circleImage
        
        imageView.contentMode = .scaleAspectFit
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(selectionImage)
        contentView.addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            textLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            textLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            
            selectionImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            selectionImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            selectionImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            selectionImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        hideSelection()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        hideSelection()
    }
    
    func showSelection() {
        selectionImage.isHidden = false
        textLabel.font = UIFont.preferredFont(forTextStyle: .callout)
    }
    
    func hideSelection() {
        selectionImage.isHidden = true
        textLabel.font = UIFont.preferredFont(forTextStyle: .body)
    }
}
