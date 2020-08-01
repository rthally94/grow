//
//  UICollectionViewWrapper.swift
//  Grow iOS
//
//  Created by Ryan Thally on 7/29/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import SwiftUI

struct CompositionalCollection<ItemIdentifier: Hashable, Content: View>: UIViewControllerRepresentable {
    var sections: [CompositionalCollectionSection<ItemIdentifier>]
    var content: (IndexPath, ItemIdentifier) -> Content
    
    func makeUIViewController(context: Context) -> UICollectionViewController {
        let collectionViewController = UICollectionViewController(collectionViewLayout: makeLayout())
        
        collectionViewController.collectionView.register(CompositionalCollectionCell<Content>.self, forCellWithReuseIdentifier: CompositionalCollectionCell<Content>.reuseIdentifier)
        
        let dataSource = makeDataSource(collectionView: collectionViewController.collectionView)
        context.coordinator.dataSource = dataSource
        
        var snapshot = NSDiffableDataSourceSnapshot<CompositionalCollectionSection<ItemIdentifier>, ItemIdentifier>()
        snapshot.appendSections(sections)
        for section in sections {
            snapshot.appendItems(section.items, toSection: section)
        }
        
        dataSource.apply(snapshot)
        
        collectionViewController.collectionView.backgroundColor = .clear
        collectionViewController.navigationItem.title = "CCV!"
        
        return collectionViewController
    }
    
    func updateUIViewController(_ uiViewController: UICollectionViewController, context: Context) {
        print("Bla")
        var snapshot = NSDiffableDataSourceSnapshot<CompositionalCollectionSection<ItemIdentifier>, ItemIdentifier>()
        snapshot.appendSections(sections)
        for section in sections {
            snapshot.appendItems(section.items, toSection: section)
        }
        
        context.coordinator.dataSource?.apply(snapshot)
    }
    
    func makeLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (section, layoutEnvirontment) -> NSCollectionLayoutSection? in
            return self.sections[section].layout()
        }
        
        return layout
    }
    
    func makeDataSource(collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<CompositionalCollectionSection<ItemIdentifier>, ItemIdentifier> {
        let dataSource = UICollectionViewDiffableDataSource<CompositionalCollectionSection<ItemIdentifier>, ItemIdentifier>(collectionView: collectionView) { collectionView, indexPath, item -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompositionalCollectionCell<Content>.reuseIdentifier, for: indexPath) as? CompositionalCollectionCell<Content> else { return nil}
            let view = self.content(indexPath, item)
            cell.configure(with: view)
            return cell
        }
        
        return dataSource
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator {
        var dataSource: UICollectionViewDiffableDataSource<CompositionalCollectionSection<ItemIdentifier>, ItemIdentifier>?
    }
}


//struct UICollectionViewWrapper<SelectionValue, Content>: UIViewRepresentable where SelectionValue: Hashable, Content: View {
//    let cellReuseIdentifier = "CollectionViewCell"
//    let headerReuseIdentifier = "CollectionViewHeader"
//
//    var content: () -> Content
//
//    func makeUIView(context: Context) -> UICollectionView {
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout() )
//
//        collectionView.register(CollectionViewCell<Content>.self, forCellWithReuseIdentifier: cellReuseIdentifier)
//
//        collectionView.backgroundColor = .clear
//
//        return collectionView
//    }
//
//    func updateUIView(_ uiView: UICollectionView, context: Context) {
//
//    }
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator()
//    }
//
//    class Coordinator: NSObject {
//
//    }
//}


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
            content.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            content.view.topAnchor.constraint(equalTo: topAnchor),
            content.view.trailingAnchor.constraint(equalTo: trailingAnchor),
            content.view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

struct CompositionalCollectionSection<Item: Hashable>: Hashable {
    static func == (lhs: CompositionalCollectionSection<Item>, rhs: CompositionalCollectionSection<Item>) -> Bool {
        lhs.id == rhs.id && lhs.items == rhs.items
    }

    var id = UUID()
    var items: [Item]
    var layout: () -> NSCollectionLayoutSection
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(items)
    }
}

class CompositionalCollectionCell<Content: View>: UICollectionViewCell {
    static var reuseIdentifier: String { "CollectionViewCellType" }
    var content: UIHostingController<Content>?
    
    func configure(with content: Content) {
        self.content = UIHostingController(rootView: content)
        configureHiearchy()
    }
    
    private func configureHiearchy() {
        guard let content = content else { return }
        
        content.view.translatesAutoresizingMaskIntoConstraints = false
        content.view.preservesSuperviewLayoutMargins = false
        
        contentView.addSubview(content.view)
        
        NSLayoutConstraint.activate([
            content.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            content.view.topAnchor.constraint(equalTo: contentView.topAnchor),
            content.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            content.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

