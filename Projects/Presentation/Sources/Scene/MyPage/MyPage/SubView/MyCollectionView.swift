import DesignSystem
import RxRelay
import RxSwift
import SnapKit
import UIKit

final class MyCollectionView: BaseView<MyCollectionItem> {
    // MARK: - Types

    typealias Section = MyCollectionSection
    typealias Item = MyCollectionItem

    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

    // MARK: - UI

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createLayout()
        )
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
        return collectionView
    }()

    // MARK: - Data

    private var dataSource: DataSource?
    private var heightConstraint: Constraint?

    // MARK: - Public

    func render(data: MyCollectionData) {
        var snapshot = Snapshot()

        // Section 1: Country Filter
        snapshot.appendSections([.countryFilter])
        let countryItems = data.countryFilter.countries.map { Item.country($0) }
        snapshot.appendItems(countryItems, toSection: .countryFilter)

        // Section 2: Souvenir Grid
        snapshot.appendSections([.souvenirGrid])
        let souvenirItems = data.souvenirGrid.souvenirs.map { Item.souvenir($0) }
        snapshot.appendItems(souvenirItems, toSection: .souvenirGrid)

        dataSource?.apply(snapshot, animatingDifferences: false) { [weak self] in
            self?.updateHeight()
        }
    }

    // MARK: - Override

    override func setAttributes() {
        backgroundColor = .clear
        configureDataSource()
    }

    override func setHierarchy() {
        addSubview(collectionView)
    }

    override func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            heightConstraint = make.height.equalTo(1).constraint
        }
    }

    private func updateHeight() {
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.layoutIfNeeded()

        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            collectionView.layoutIfNeeded()
            let h = collectionView.collectionViewLayout.collectionViewContentSize.height
            heightConstraint?.update(offset: h)
            superview?.layoutIfNeeded()
        }
    }
}

// MARK: - Diffable / CellRegistration

private extension MyCollectionView {
    func configureDataSource() {
        let countryRegistration = UICollectionView.CellRegistration<
            CountryFilterCell,
            Item
        > { cell, _, item in
            if case let .country(countryItem) = item {
                cell.render(countryItem)
            }
        }

        let souvenirRegistration = UICollectionView.CellRegistration<
            SouvenirThumbnailCell,
            Item
        > { cell, _, item in
            if case let .souvenir(souvenir) = item {
                cell.render(souvenir)
            }
        }

        dataSource = .init(
            collectionView: collectionView
        ) { collectionView, indexPath, item in
            switch item {
            case .country:
                collectionView.dequeueConfiguredReusableCell(
                    using: countryRegistration,
                    for: indexPath,
                    item: item
                )
            case .souvenir:
                collectionView.dequeueConfiguredReusableCell(
                    using: souvenirRegistration,
                    for: indexPath,
                    item: item
                )
            }
        }
    }
}

// MARK: - CollectionView Layout

private extension MyCollectionView {
    func createLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self,
                  let sectionKind = dataSource?.sectionIdentifier(for: sectionIndex)
            else { return nil }

            switch sectionKind {
            case .countryFilter:
                return createCountryFilterSection()
            case .souvenirGrid:
                return createSouvenirGridSection()
            }
        }
    }

    func createCountryFilterSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(50),
            heightDimension: .absolute(30)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(50),
            heightDimension: .absolute(30)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 8
        section.contentInsets = .init(
            top: 16,
            leading: 20,
            bottom: 0,
            trailing: 20
        )

        return section
    }

    func createSouvenirGridSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalWidth(0.5)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.5)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item, item]
        )
        group.interItemSpacing = .fixed(8)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 26,
            leading: 20,
            bottom: 0,
            trailing: 20
        )

        return section
    }
}

// MARK: - UICollectionView Delegate

extension MyCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource?.itemIdentifier(for: indexPath) else { return }
        action.accept(item)
    }
}
