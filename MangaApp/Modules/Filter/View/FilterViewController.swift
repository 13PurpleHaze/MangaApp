//
//  FilterViewController.swift
//  MangaApp
//
//  Created by Никита Новицкий on 04.08.2025.
//

import UIKit

enum FilterSection {
    case order
}

struct FilterOption: Hashable {
    var id: String
    var title: String
    var isSelected: Bool
}

class FilterViewController: UIViewController {
    private var fieldsCollectionView: UICollectionView!
    let presenter: FilterViewOutput
    var onFinish: (() -> Void)?

    init(presenter: FilterViewOutput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    private func configureUI() {
        title = "Filter".localizable()
        view.backgroundColor = .systemBackground
        configureNavBar()
        configureFieldsCollectionView()
        loadFilter()
        configureButton()
    }

    private func configureNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Clear".localizable(), style: .done, target: self, action: #selector(clear))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(onCancel))
    }

    private func configureButton() {
        let button = UIButton()
        button.setTitle("Show results".localizable(), for: .normal)
        button.configuration = .filled()
        button.configuration?.baseBackgroundColor = .systemBlue
        button.addTarget(self, action: #selector(onComplete), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)

        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    private func configureFieldsCollectionView() {
        fieldsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
        fieldsCollectionView.dataSource = self
        fieldsCollectionView.delegate = self
        fieldsCollectionView.allowsMultipleSelection = true
        fieldsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        fieldsCollectionView.register(FieldCell.self, forCellWithReuseIdentifier: FieldCell.reuseIdentifier)
        fieldsCollectionView.register(
            FieldHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: FieldHeader.reuseIdentifier
        )
        view.addSubview(fieldsCollectionView)

        NSLayoutConstraint.activate([
            fieldsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            fieldsCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            fieldsCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            fieldsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    private func makeLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (_: Int, _: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(100), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(30))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(16)

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 16
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16)

            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(40))
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            section.boundarySupplementaryItems = [header]

            return section
        }

        return layout
    }

    // MARK: - Presenter

    private func loadFilter() {
        presenter.loadFilter()
    }

    private func saveFields() {
        presenter.saveFilter()
    }

    // MARK: - Actions

    @objc func onComplete() {
        saveFields()
        onFinish?()
        presenter.closeFilter()
    }

    @objc func clear() {
        presenter.clearFilter()
    }

    @objc func onCancel() {
        presenter.closeFilter()
    }
}

extension FilterViewController: UICollectionViewDataSource {
    func numberOfSections(in _: UICollectionView) -> Int {
        presenter.filterValues.fieldsCount
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return presenter.filterValues.order.count
        case 1:
            return presenter.filterValues.contentRating.count
        case 2:
            return presenter.filterValues.status.count
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FieldCell.reuseIdentifier, for: indexPath) as? FieldCell else {
            return UICollectionViewCell()
        }
        switch indexPath.section {
        case 0:
            cell.setTitle(presenter.filterValues.order[indexPath.item].localized)
        case 1:
            cell.setTitle(presenter.filterValues.contentRating[indexPath.item].localized)
        case 2:
            cell.setTitle(presenter.filterValues.status[indexPath.item].localized)
        default:
            // nothing
            return cell
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FieldHeader.reuseIdentifier, for: indexPath) as? FieldHeader else {
                return UICollectionReusableView()
            }
            switch indexPath.section {
            case 0:
                header.configure(title: "Order by:".localizable())
            case 1:
                header.configure(title: "Content rating".localizable())
            case 2:
                header.configure(title: "Status".localizable())
            default:
                header.configure(title: "Section")
            }
            return header
        }
        return UICollectionReusableView()
    }
}

extension FilterViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if let order = presenter.filter.order, let index = presenter.filterValues.order.firstIndex(of: order) {
                let oldIndexPath = IndexPath(row: index, section: 0)
                collectionView.deselectItem(at: oldIndexPath, animated: true)
            }
            presenter.filter.order = presenter.filterValues.order[indexPath.item]
        case 1:
            presenter.filter.contentRating.append(presenter.filterValues.contentRating[indexPath.item])
        case 2:
            presenter.filter.status.append(presenter.filterValues.status[indexPath.item])
        default:
            return
        }
    }

    func collectionView(_: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            presenter.filter.order = nil
        case 1:
            presenter.filter.contentRating = presenter.filter.contentRating.filter {
                $0 != presenter.filterValues.contentRating[indexPath.item]
            }
        case 2:
            presenter.filter.status = presenter.filter.status.filter {
                $0 != presenter.filterValues.status[indexPath.item]
            }
        default:
            return
        }
    }
}

extension FilterViewController: FilterViewInput {
    func setSelectedFields() {
        if let order = presenter.filter.order {
            if let index = presenter.filterValues.order.firstIndex(where: { $0 == order }) {
                fieldsCollectionView.selectItem(at: IndexPath(item: index, section: 0), animated: false, scrollPosition: [])
            }
        }
        if !presenter.filter.contentRating.isEmpty {
            for item in presenter.filter.contentRating {
                if let index = presenter.filterValues.contentRating.firstIndex(where: { $0 == item }) {
                    fieldsCollectionView.selectItem(at: IndexPath(item: index, section: 1), animated: false, scrollPosition: [])
                }
            }
        }
        if !presenter.filter.status.isEmpty {
            for item in presenter.filter.status {
                if let index = presenter.filterValues.status.firstIndex(where: { $0 == item }) {
                    fieldsCollectionView.selectItem(at: IndexPath(item: index, section: 2), animated: false, scrollPosition: [])
                }
            }
        }
    }

    func clearSelections() {
        fieldsCollectionView.indexPathsForSelectedItems?.forEach {
            fieldsCollectionView.deselectItem(at: $0, animated: false)
        }
    }
}
