import Domain
import RxRelay
import RxSwift
import SnapKit
import UIKit

final class CategoryGridView: UIView {
    // MARK: - Action

    let toggle = PublishRelay<Item>()
    private let disposeBag = DisposeBag()

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
        view.delegate = self
        return view
    }()

    // MARK: - Data

    private var dataSource: DataSource?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Public

    func render(items: [Item]) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(items, toSection: 0)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - UI Configuration

private extension CategoryGridView {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        backgroundColor = .clear
        configureDataSource()
    }

    func setHierarchy() {
        addSubview(collectionView)
    }

    func setConstraints() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
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

// MARK: - UICollectionView Delegate

extension CategoryGridView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource?.itemIdentifier(for: indexPath) else { return }
        toggle.accept(item)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let item = dataSource?.itemIdentifier(for: indexPath) else { return }
        toggle.accept(item)
    }
}
