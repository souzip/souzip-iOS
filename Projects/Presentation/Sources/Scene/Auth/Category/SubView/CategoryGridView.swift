import Domain
import RxSwift
import SnapKit
import UIKit

final class CategoryGridView: BaseView<CategoryItem> {
    // MARK: - Types

    typealias Section = Int
    typealias Item = CategoryItem

    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

    // MARK: - UI

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: makeCVLayout())
        view.backgroundColor = .clear
        view.isScrollEnabled = false
        view.showsVerticalScrollIndicator = false
        view.allowsMultipleSelection = true
        return view
    }()

    // MARK: - Data

    private var dataSource: DataSource?

    // MARK: - Override

    override func setAttributes() {
        backgroundColor = .clear
        configureDataSource()
    }

    override func setHierarchy() {
        addSubview(collectionView)
    }

    override func setConstraints() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override func setBindings() {
        bind(
            Observable.merge(
                collectionView.rx.itemSelected.asObservable(),
                collectionView.rx.itemDeselected.asObservable()
            )
        )
        .compactMap { [weak self] in self?.dataSource?.itemIdentifier(for: $0) }
    }

    // MARK: - Public

    func render(items: [Item]) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(items, toSection: 0)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - Diffable / CellRegistration

private extension CategoryGridView {
    func configureDataSource() {
        let registration = UICollectionView.CellRegistration<
            CategoryChipCell,
            Item
        > { cell, _, item in
            cell.render(item: item)
        }

        dataSource = .init(
            collectionView: collectionView
        ) { collectionView, indexPath, item in
            collectionView.dequeueConfiguredReusableCell(
                using: registration,
                for: indexPath,
                item: item
            )
        }
    }
}

// MARK: - CollectionView Layout

private extension CategoryGridView {
    func makeCVLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(120),
            heightDimension: .absolute(44)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(44)
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.interItemSpacing = .fixed(8)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8

        return UICollectionViewCompositionalLayout(section: section)
    }
}
