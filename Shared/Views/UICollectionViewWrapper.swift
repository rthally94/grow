//
//  UICollectionViewWrapper.swift
//  Grow iOS
//
//  Created by Ryan Thally on 7/29/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI

struct UICollectionViewWrapper<Section: Hashable, ItemIdentifier: Hashable, Header: View, Content: View>: UIViewRepresentable {
    let cellReuseIdentifier = "CollectionViewCell"
    let headerReuseIdentifier = "CollectionViewHeader"
    
    var sections: [Section]
    var items: [ItemIdentifier]
    var sectionHeader: (Section) -> Header
    var content: (IndexPath) -> Content
    
    func makeUIView(context: Context) -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: context.coordinator.configureLayout())
    
        collectionView.register(CollectionViewCell<Content>.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView.register(CollectionViewSectionHeaderFooter<Header>.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
//        let dataSource = UICollectionViewDiffableDataSource<Section, ItemIdentifier>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TestCell.reuseID, for: indexPath) as? TestCell
////            let view = self.content(indexPath)
////            cell?.configure(with: { view })
//            return cell
//        }
        
        collectionView.dataSource = context.coordinator
//        updateDataSource(dataSource)
//        context.coordinator.dataSource = dataSource
        
        collectionView.delegate = context.coordinator
        collectionView.backgroundColor = .clear
        
        return collectionView
    }
    
    func updateUIView(_ uiView: UICollectionView, context: Context) {
//        guard let dataSource = context.coordinator.dataSource else { return }
//        updateDataSource(dataSource)
    }
    
    func updateDataSource(_ dataSource: UICollectionViewDiffableDataSource<Section, ItemIdentifier>) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ItemIdentifier>()
        snapshot.appendSections(sections)
        snapshot.appendItems(items)
        
        dataSource.apply(snapshot)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            parent.sections.count
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            10
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: parent.cellReuseIdentifier, for: indexPath) as? CollectionViewCell<Content> else { fatalError() }
            cell.configure(with: { parent.content(indexPath) })
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: parent.headerReuseIdentifier, for: indexPath) as? CollectionViewSectionHeaderFooter<Header> else { fatalError("Invalid view type") }
                header.configure(with: parent.sectionHeader(parent.sections[indexPath.section]))
                return header
            default:
                assert(false, "Invalid element type")
            }
        }
        
        var parent: UICollectionViewWrapper
        var dataSource: UICollectionViewDiffableDataSource<Section, ItemIdentifier>?
        
        init(_ parent: UICollectionViewWrapper) {
            self.parent = parent
        }

        func configureLayout() -> UICollectionViewLayout {
            let layout  = UICollectionViewCompositionalLayout { (section: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.2))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(200))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 3)

                let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerFooterSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
//                header.pinToVisibleBounds = true
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
                section.interGroupSpacing = 24
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0)
                section.boundarySupplementaryItems = [header]
                
                return section
            }

            return layout
//            return UICollectionViewFlowLayout()
        }
    }
}

class CollectionViewSectionHeaderFooter<Content: View>: UICollectionReusableView {
    var content: UIHostingController<Content>?
    
    func configure(with content: Content) {
        self.content = UIHostingController(rootView: content)
        configureHiearchy()
    }
    
    private func configureHiearchy() {
       guard let content = content else { fatalError("Content is not configured") }
        
        content.view.translatesAutoresizingMaskIntoConstraints = false
        content.view.preservesSuperviewLayoutMargins = false
        
        addSubview(content.view)
        
        NSLayoutConstraint.activate([
            content.view.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            content.view.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            content.view.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            content.view.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
        ])
    }
}

class CollectionViewCell<Content: View>: UICollectionViewCell {
    var content: UIHostingController<Content>?
    
    func configure(with content: () -> Content) {
        self.content = UIHostingController(rootView: content())
        configureHiearchy()
    }
    
    private func configureHiearchy() {
        guard let content = content else { return }
        
        content.view.translatesAutoresizingMaskIntoConstraints = false
        content.view.preservesSuperviewLayoutMargins = false
        
        contentView.addSubview(content.view)
        
        NSLayoutConstraint.activate([
            content.view.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            content.view.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            content.view.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            content.view.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])
    }
    
    
}
