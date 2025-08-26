//
//  MangaListViewController.swift
//  MangaApp
//
//  Created by Никита Новицкий on 30.07.2025.
//

import UIKit

class MangaListViewController: UIViewController {
    var presenter: MangaListViewOutput
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Int, Manga>!
    private let refreshControll = UIRefreshControl()
    private let containerView = UIView()
    private let historyViewController: HistoryViewController
    private var filterButton: UIBarButtonItem!
    private var loader = BackgroundLoader()
    private var banner = Banner()

    private var page = 1
    
    init(presenter: MangaListViewOutput, historyViewController: HistoryViewController) {
        self.presenter = presenter
        self.historyViewController = historyViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        setupContainerView()
        setupNavBar()
        setupCollectionView()
        setupHistoryView()
        presenter.fetchFilterFields()
        fetchMangas()
    }
    
    private func setupContainerView() {
        containerView.frame = view.frame
        containerView.center = view.center
        containerView.backgroundColor = .systemBackground
        view.addSubview(containerView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        presenter.filter.search = nil
        presenter.saveFilter()
    }
}

// MARK: - History
extension MangaListViewController: HistoryPresenterOutput {
    private func setupHistoryView() {
        addChild(historyViewController)
        historyViewController.view.frame = view.frame
        historyViewController.presenter.delegate = self
        let historyView = historyViewController.view!
        historyView.alpha = 0
        view.addSubview(historyView)
    }
    
    func didSelect(text: String) {
        guard let searchBar = navigationItem.searchController?.searchBar else { return }
        searchBar.text = text
        
        presenter.filter.search = text
        presenter.saveFilter()
        
        fetchMangas()
        
        UIView.animate(withDuration: 0.3) {
            self.containerView.alpha = 1
            self.historyViewController.view.alpha = 0
        }
        
        searchBar.resignFirstResponder()
    }
    
}

// MARK: - CollectionView
extension MangaListViewController {
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        collectionView.register(MangaCell.self, forCellWithReuseIdentifier: MangaCell.reuseIdentifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(SectionFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: SectionFooter.reuseIdentifier)
        collectionView.delegate = self
        containerView.addSubview(collectionView)
        
        refreshControll.addTarget(self, action: #selector(refreshMangas), for: .valueChanged)
        collectionView.refreshControl = refreshControll
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MangaCell.reuseIdentifier, for: indexPath) as? MangaCell else {
                return UICollectionViewCell()
            }
            
            cell.setValues(title: item.title, imageURL: item.coverImageURL)
            return cell
        }
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            if kind == UICollectionView.elementKindSectionFooter {
                guard let footer = self.collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionFooter.reuseIdentifier, for: indexPath) as? SectionFooter else {
                    return UICollectionReusableView()
                }
                self.presenter.state == .isEndReached ? footer.stopAnimating() : footer.startAnimating()
                return footer
            }
            return nil
        }
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func createCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (view.bounds.width - 32 - 16) / 2, height: 250)
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.footerReferenceSize = CGSize(width: view.bounds.width, height: 60)
        return layout
    }
    
    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Manga>()
        snapshot.appendSections([0])
        snapshot.appendItems(presenter.mangas, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    @objc func refreshMangas() {
        page = 1
        presenter.filter.offset = (page - 1) * presenter.filter.limit
        presenter.fetchMangas()
        refreshControll.endRefreshing()
    }
}

extension MangaListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item > presenter.mangas.count - 5 && presenter.mangas.count >= 10 {
            if presenter.state != .isFetching {
                page += 1
                presenter.filter.offset = (page - 1) * presenter.filter.limit
                presenter.fetchMangas()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.openDetail(index: indexPath.row)
    }
}

// MARK: - NavBar setup
extension MangaListViewController: UISearchBarDelegate {
    private func setupNavBar() {
        navigationItem.searchController = UISearchController()
        navigationItem.searchController?.searchBar.delegate = self
        navigationItem.backButtonDisplayMode = .minimal

        let button = UIButton()
        button.setImage(UIImage(systemName: "line.3.horizontal.decrease")?.withTintColor(.label, renderingMode: .alwaysOriginal), for: .normal)
        
        filterButton = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = filterButton

        button.addTarget(self, action: #selector(openFilter), for: .touchUpInside)
    }
    
    @objc func openFilter() {
        presenter.openFilter {
            self.presenter.fetchFilterFields()
            self.page = 1
            self.presenter.fetchMangas()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.3) {
            self.containerView.alpha = 0
            self.historyViewController.view.alpha = 1
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter.filter.search = nil
        presenter.saveFilter()
        UIView.animate(withDuration: 0.3) {
            self.containerView.alpha = 1
            self.historyViewController.view.alpha = 0
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter.filter.search = searchBar.searchTextField.text
        presenter.saveFilter()
        fetchMangas()
        UIView.animate(withDuration: 0.3) {
            self.containerView.alpha = 1
            self.historyViewController.view.alpha = 0
        }
    }
}

// MARK: - Fetch mangas
extension MangaListViewController {
    private func fetchMangas() {
        presenter.filter.offset = presenter.filter.limit * (page - 1)
        presenter.fetchMangas()
    }
}

// MARK: - MangaListViewInput
extension MangaListViewController: MangaListViewInput {
    func setFilter(filter: Filter) {
        let count = countNotNilAndNotEmptyFields(of: presenter.filter)
        filterButton.setBadge(text: count > 0 ? "\(count)" : nil)
    }
    
    func updateUI(state: ViewState) {
        print(state, page)
        switch state {
        case .isFetching:
            banner.hide()
            if page == 1 {
                collectionView.alpha = 0
                loader.show(in: containerView)
            }
        case .isError:
            loader.hide()
            collectionView.alpha = 0
            banner.showError(in: containerView, reteryAction: fetchMangas)
        case .isEndReached:
            if let footer = collectionView.supplementaryView(
                forElementKind: UICollectionView.elementKindSectionFooter,
                at: IndexPath(item: 0, section: 0)
            ) as? SectionFooter {
                footer.stopAnimating()
            }
            applySnapshot()
        case .isSuccess:
            loader.hide()
            if presenter.mangas.isEmpty {
                banner.showEmptyData(in: containerView, reteryAction: fetchMangas)
            } else {
                collectionView.alpha = 1
                applySnapshot()
            }
        }
        
    }
}
