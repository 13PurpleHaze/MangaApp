//
//  ChapterDetailViewController.swift
//  MangaApp
//
//  Created by Никита Новицкий on 20.08.2025.
//

import UIKit

class ChapterDetailViewController: UIViewController {
    let presenter: ChapterDetailViewOutput
    var chapterID: String!
    var chapterNumber: Int!

    private var collectionView: UICollectionView!
    private var isNavigationBarHidden = true
    private let loader = BackgroundLoader()
    private let banner = Banner()

    init(presenter: ChapterDetailViewOutput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        setupNavBar()
        setupCollectionView()
        setupTapGesture()
        fetchChapter()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    private func setupNavBar() {
        title = "Chapter".localizable(chapterNumber)
    }

    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        tapGesture.cancelsTouchesInView = true
        view.addGestureRecognizer(tapGesture)
    }

    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ChapterImageCell.self, forCellWithReuseIdentifier: ChapterImageCell.reuseIdentifier)
        collectionView.showsVerticalScrollIndicator = false

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func makeLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let width = view.bounds.width
        layout.itemSize = CGSize(width: width, height: width * 1.5)

        layout.scrollDirection = .vertical
        return layout
    }

    // MARK: - Actions

    @objc func onTap() {
        toggleNavigationBar()
    }

    private func toggleNavigationBar() {
        isNavigationBarHidden.toggle()
        navigationController?.setNavigationBarHidden(isNavigationBarHidden, animated: true)
    }
}

extension ChapterDetailViewController {
    private func fetchChapter() {
        presenter.fetchChapter(chapterID: chapterID)
    }
}

extension ChapterDetailViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        presenter.chapters.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChapterImageCell.reuseIdentifier, for: indexPath) as? ChapterImageCell else {
            return UICollectionViewCell()
        }
        cell.configure(imageURL: presenter.chapters[indexPath.item])
        return cell
    }
}

extension ChapterDetailViewController: ChapterDetailViewInput {
    func updateUI(state: ViewState) {
        print(state)
        switch state {
        case .isFetching:
            banner.hide()
            collectionView.alpha = 0
            loader.show(in: view)
        case .isError:
            loader.hide()
            banner.showError(in: view, reteryAction: fetchChapter)
        case .isSuccess:
            loader.hide()
            collectionView.alpha = 1
            collectionView.reloadData()
        default:
            return // do nothing
        }
    }
}
