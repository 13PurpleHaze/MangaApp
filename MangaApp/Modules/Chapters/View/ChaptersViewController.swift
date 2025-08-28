//
//  ChaptersViewController.swift
//  MangaApp
//
//  Created by Никита Новицкий on 19.08.2025.
//

import UIKit

class ChaptersViewController: UIViewController {
    let presenter: ChaptersViewOutput
    private var page = 1
    private let limit = 10
    var mangaID: String?

    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<String, Chapter>!
    private var loader = BackgroundLoader()
    private var banner = Banner()
    private let stackView = UIStackView()
    private var translated = false

    init(presenter: ChaptersViewOutput) {
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
        view.backgroundColor = .systemBackground
        navigationItem.backButtonDisplayMode = .minimal
        setupSwitch()
        setupCollectionView()
        fetchChapters()
    }

    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ChapterCell.self, forCellWithReuseIdentifier: ChapterCell.reuseIdentifier)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseIdentifier)

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])

        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChapterCell.reuseIdentifier, for: indexPath) as? ChapterCell else {
                return UICollectionViewCell()
            }
            cell.configure(
                title: "Chapter".localizable(
                    Int(item.attributes.chapter ?? "0") ?? 0
                ),
                language: item.attributes.translatedLanguage ?? "",
                pages: String(item.attributes.pages ?? 0)
            )
            return cell
        }

        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            if kind == UICollectionView.elementKindSectionHeader {
                guard let section = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseIdentifier, for: indexPath) as? SectionHeader else {
                    return UICollectionReusableView()
                }
                let snapshot = self.dataSource.snapshot()
                let volume = snapshot.sectionIdentifiers[indexPath.section]
                section.setTitle(title: "Volume".localizable(Int64(volume)!))
                return section
            } else {
                return UICollectionReusableView()
            }
        }
    }

    private func makeLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { _, _ -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(44)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: groupSize,
                subitems: [item]
            )

            let section = NSCollectionLayoutSection(group: group)

            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(44)
            )
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            header.contentInsets = .init(top: 8, leading: 16, bottom: 0, trailing: 0)
            section.boundarySupplementaryItems = [header]

            return section
        }

        return layout
    }

    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<String, Chapter>()
        presenter.chaptersByVolume.keys
            .compactMap { Int($0) }
            .sorted()
            .reversed()
            .map { String($0) }
            .forEach {
                snapshot.appendSections([$0])
                snapshot.appendItems(presenter.chaptersByVolume[$0]!, toSection: $0)
            }

        dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func setupSwitch() {
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        let titleLabel = UILabel()
        titleLabel.text = "Translated chapters".localizable()
        titleLabel.font = .preferredFont(forTextStyle: .title3)

        let switchView = UISwitch()
        switchView.isOn = translated
        switchView.addTarget(self, action: #selector(handleSwitchValueChanged), for: .valueChanged)

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(switchView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            stackView.heightAnchor.constraint(equalToConstant: 44),
        ])
    }

    @objc func handleSwitchValueChanged() {
        translated.toggle()
        page = 1
        fetchChapters()
    }
}

// MARK: - Presenter

extension ChaptersViewController {
    private func fetchChapters() {
        presenter.fetchChapters(mangaID: mangaID!, translated: translated, limit: limit, offset: (page - 1) * limit)
    }
}

extension ChaptersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay _: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if presenter.state != .isEndReached, indexPath.section + 1 == collectionView.numberOfSections, presenter.state != .isFetching, presenter.chapters.count >= limit {
            page += 1
            fetchChapters()
        }
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let snapshot = dataSource.snapshot()
        let volume = snapshot.sectionIdentifiers[indexPath.section]
        guard let chapters = presenter.chaptersByVolume[volume] else { return }

        presenter.openChapter(
            chapterID: chapters[indexPath.item].id,
            chapterNumber: Int(chapters[indexPath.item].attributes.chapter ?? "0") ?? 0
        )
    }
}

extension ChaptersViewController: ChaptersViewInput {
    func updateUI(state: ViewState) {
        switch state {
        case .isFetching:
            banner.hide()
            if page == 1 {
                collectionView.alpha = 0
                loader.show(in: view)
            }
        case .isError:
            loader.hide()
            banner.showError(in: view, reteryAction: fetchChapters)
        case .isSuccess:
            loader.hide()
            collectionView.alpha = 1
            if presenter.chapters.isEmpty {
                banner.showEmptyData(in: view, reteryAction: fetchChapters)
            }
            applySnapshot()
        case .isEndReached:
            loader.hide()
            collectionView.alpha = 1
            if presenter.chapters.isEmpty {
                banner.showEmptyData(in: view, reteryAction: fetchChapters)
            }
            applySnapshot()
        }
    }
}
