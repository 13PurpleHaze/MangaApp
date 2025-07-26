//
//  HomeViewController.swift
//  MangaApp
//
//  Created by Никита Новицкий on 30.07.2025.
//

import UIKit

enum MangaSection: String, Hashable, CaseIterable {
    case mostPopular = "Most popular"
    case new = "New"
    case highestRated = "Highest rated"
}

class HomeViewController: UIViewController {
    let presenter: HomeViewOutput
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<MangaSection, Manga>!
    private var loader = BackgroundLoader()
    private var banner = Banner()
    
    init(presenter: HomeViewOutput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchHomeMangas()
    }
    
    private func configureUI() {
        navigationItem.backButtonDisplayMode = .minimal
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(MangaCell.self, forCellWithReuseIdentifier: MangaCell.reuseIdentifier)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseIdentifier)
        collectionView.showsVerticalScrollIndicator = false
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { (collectionView, indexPath, item) in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MangaCell.reuseIdentifier, for: indexPath) as? MangaCell else {
                return UICollectionViewCell()
            }
            
            cell.setValues(title: item.title, imageURL: item.coverImageURL)
            return cell
        }
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            guard kind == UICollectionView.elementKindSectionHeader else {
                return UICollectionReusableView()
            }
            guard let section = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseIdentifier, for: indexPath) as? SectionHeader else {
                return UICollectionReusableView()
            }
            section.setTitle(title: self.dataSource.snapshot().sectionIdentifiers[indexPath.section].rawValue.localizable())
            return section
        }
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.alpha = 0
        collectionView.delegate = self
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(120), heightDimension: .absolute(200))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 16
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 20, trailing: 16)
            section.orthogonalScrollingBehavior = .continuous
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(60))
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
            section.boundarySupplementaryItems = [header]
            
            return section
        }
        return layout
    }
    
    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<MangaSection, Manga>()
        snapshot.appendSections([.highestRated, .mostPopular, .new])
        snapshot.appendItems(presenter.highestRatedManga, toSection: .highestRated)
        snapshot.appendItems(presenter.popularManga, toSection: .mostPopular)
        snapshot.appendItems(presenter.newManga, toSection: .new)

        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            presenter.openDetail(manga: presenter.highestRatedManga[indexPath.item])
        case 1:
            presenter.openDetail(manga: presenter.popularManga[indexPath.item])
        case 2:
            presenter.openDetail(manga: presenter.newManga[indexPath.item])
        default:
            return
        }
    }
}


extension HomeViewController: HomeViewInput {
    func updateUI(state: ViewState) {
        print(state)
        switch state {
        case .isFetching:
            banner.hide()
            loader.show(in: view)
            collectionView.alpha = 0
        case .isError:
            loader.hide()
            banner.showError(in: view, reteryAction: fetchHomeMangas)
        case .isSuccess:
            loader.hide()
            collectionView.alpha = 1
            applySnapshot()
        case .isEndReached:
            return // do nothing
        }
    }
}

extension HomeViewController {
    private func fetchHomeMangas() {
        presenter.fetchManga()
    }
}
