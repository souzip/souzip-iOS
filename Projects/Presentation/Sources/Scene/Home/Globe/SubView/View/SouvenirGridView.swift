import DesignSystem
import Domain
import RxSwift
import SnapKit
import UIKit

// MARK: - SouvenirGridAction

enum SouvenirGridAction {
    case itemTap(SouvenirListItem)
    case shouldDismissSheet
    case tapUpload
}

// MARK: - SouvenirGridView

final class SouvenirGridView: BaseView<SouvenirGridAction> {
    // MARK: - Types

    typealias Section = Int
    typealias Item = SouvenirListItem // 기념품 모델

    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

    // MARK: - UI

    private let titleLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.text = "근처에 있는 기념품이에요"
        label.textColor = .dsGreyWhite
        label.setTypography(.body1SB)
        return label
    }()

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: makeCVLayout())
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = true
        view.bounces = false
        return view
    }()

    private let emptyView = SouvenirEmptyView()

    // MARK: - Data

    private var dataSource: DataSource?

    // MARK: - Override

    override func setAttributes() {
        backgroundColor = .clear
        configureDataSource()
    }

    override func setHierarchy() {
        [
            titleLabel,
            collectionView,
            emptyView,
        ].forEach(addSubview)
    }

    override func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(27)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        emptyView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(55)
            make.centerX.equalToSuperview()
        }
    }

    override func setBindings() {
        bind(collectionView.rx.itemSelected)
            .compactMap { [weak self] in self?.dataSource?.itemIdentifier(for: $0) }
            .map { .itemTap($0) }

        bind(collectionView.rx.contentOffset)
            .filter { $0.y < 0 }
            .map { _ in .shouldDismissSheet }

        bind(emptyView.tapUpload)
            .to(.tapUpload)
    }

    // MARK: - Public

    func render(items: [Item]) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(items, toSection: 0)
        dataSource?.apply(snapshot, animatingDifferences: false)

        updateEmptyState(isEmpty: items.isEmpty)
    }

    // MARK: - Private

    private func updateEmptyState(isEmpty: Bool) {
        titleLabel.isHidden = isEmpty
        collectionView.isHidden = isEmpty
        emptyView.isHidden = !isEmpty
    }
}

// MARK: - Diffable / CellRegistration

private extension SouvenirGridView {
    func configureDataSource() {
        let registration = UICollectionView.CellRegistration<
            SouvenirGridCell,
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

private extension SouvenirGridView {
    func makeCVLayout() -> UICollectionViewLayout {
        let horizontalInset: CGFloat = 20
        let interItemSpacing: CGFloat = 7
        let lineSpacing: CGFloat = 25

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .estimated(230)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(230)
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item, item]
        )
        group.interItemSpacing = .fixed(interItemSpacing)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = lineSpacing
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: horizontalInset,
            bottom: horizontalInset,
            trailing: horizontalInset
        )

        return UICollectionViewCompositionalLayout(section: section)
    }
}
