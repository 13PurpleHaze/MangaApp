//
//  MangaDetailViewController.swift
//  MangaApp
//
//  Created by Никита Новицкий on 13.08.2025.
//

import UIKit
import Kingfisher

enum Section: Hashable {
    case image
    case description
    case chapterLink
    case characteristics
}

enum Item: Hashable {
    case image(String, String)
    case description(String)
    case chapterLink
    case characteristic(key: String, value: String)
}

class MangaDetailViewController: UIViewController, MangaDetailViewInput {
    var presenter: MangaDetailViewOutput
    var manga: Manga?
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    private var sectionOrder: [Section] = [.image, .description, .chapterLink, .characteristics]
    
    
    init(presenter: MangaDetailViewOutput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupCollectionView()
        applySnapshot()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if collectionView.contentOffset.y > ImageCell.defaultHeight - view.safeAreaInsets.top - 44 {
            updateNavigationBar(show: true)
        } else {
            updateNavigationBar(show: false)
        }
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateNavigationBar(show: true)
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Navigation bar
    private func setupNavigationBar() {
        title = manga?.title ?? "Manga".localizable()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.backButtonDisplayMode = .minimal
    }
    
    private func updateNavigationBar(show: Bool) {
        UIView.animate(withDuration: 1) {
            self.navigationController?.navigationBar.titleTextAttributes = [
                .foregroundColor: show ? UIColor.label : UIColor.clear
            ]
            self.navigationController?.navigationBar.setBackgroundImage(show ? nil : UIImage(), for: .default)
        }
    }
    
    // MARK: - CollectionView
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseIdentifier)
        collectionView.register(DescriptionCell.self, forCellWithReuseIdentifier: DescriptionCell.reuseIdentifier)
        collectionView.register(CharacteristicCell.self, forCellWithReuseIdentifier: CharacteristicCell.reuseIdentifier)
        collectionView.register(ChaptersLinkCell.self, forCellWithReuseIdentifier: ChaptersLinkCell.reuseIdentifier)
        collectionView.register(
            CharacteristicsHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CharacteristicsHeader.reuseIdentifier
        )
        collectionView.contentInsetAdjustmentBehavior = .never
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { (collectionView, indexPath, item) in
            switch item {
            case .image(let imageURL, let title):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseIdentifier, for: indexPath) as? ImageCell else {
                    return UICollectionViewCell()
                }
                cell.configure(image: imageURL, title: title)
                return cell
            case .description(let description):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DescriptionCell.reuseIdentifier, for: indexPath) as? DescriptionCell else {
                    return UICollectionViewCell()
                }
                cell.configure(text: description)
                return cell
            case .chapterLink:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChaptersLinkCell.reuseIdentifier, for: indexPath) as? ChaptersLinkCell else {
                    return UICollectionViewCell()
                }
                cell.configure(title: "Show manga chapters".localizable())
                return cell
            case .characteristic(let key, let value):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacteristicCell.reuseIdentifier, for: indexPath) as? CharacteristicCell else {
                    return UICollectionViewCell()
                }
               
                cell.configure(key: key, value: value)
                return cell
            }
        }
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            if kind == UICollectionView.elementKindSectionHeader {
                guard let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: CharacteristicsHeader.reuseIdentifier,
                    for: indexPath
                ) as? CharacteristicsHeader else {
                    return UICollectionReusableView()
                }
                header.configure(title: "Characteristics".localizable())
                return header
            }
            return UICollectionReusableView()
        }
    }
    
    private func applySnapshot() {
        guard let manga = manga else { return }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        
        snapshot.appendSections([.image, .description, .chapterLink])
        snapshot.appendItems([.image(manga.coverImageURL ?? "", manga.title)], toSection: .image)
        snapshot.appendItems([.description(manga.description ?? "")], toSection: .description)
        snapshot.appendItems([.chapterLink], toSection: .chapterLink)

        if let characteristics = manga.characteristics, !characteristics.isEmpty {
            snapshot.appendSections([.characteristics])
            let characteristicItems = characteristics.map { key, value in
                Item.characteristic(key: key, value: value)
            }
            snapshot.appendItems(characteristicItems, toSection: .characteristics)
        }
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    // MARK: - Layout makers
    // TODO: почему тут [weak self]???
    private func makeLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int, layoutEnv: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            
            switch sectionOrder[sectionIndex] {
            case .image:
                return self.makePhotoLayout()
            case .description, .chapterLink:
                return self.makeDescriptionLayout()
            case .characteristics:
                return self.makeCharacteristicsLayout()
            }
        }
        return layout
    }
    
    private func makePhotoLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(ImageCell.defaultHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        section.orthogonalScrollingBehavior = .paging
        
        return section
    }
    
    private func makeDescriptionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(30))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(30))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16)
        return section
    }
    
    private func makeCharacteristicsLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.3))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(150))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item, item, item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0)
        section.orthogonalScrollingBehavior = .paging

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(40))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        header.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
}

// MARK: - Delegate
extension MangaDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            presenter.openChaptersList(mangaID: manga?.id ?? "")
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? ImageCell {
            cell.handleScroll(offsetY: scrollView.contentOffset.y)
        }
        
        // TODO: исправить 40
        if scrollView.contentOffset.y > ImageCell.defaultHeight - view.safeAreaInsets.top - 44 {
            updateNavigationBar(show: true)
        } else {
            updateNavigationBar(show: false)
        }
    }
}
