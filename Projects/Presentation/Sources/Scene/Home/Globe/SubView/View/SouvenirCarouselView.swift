import Domain
import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class SouvenirCarouselView: UIView {
    // MARK: - Action

    let itemTapped = PublishRelay<SouvenirListItem>()
    let closeButtonTapped = PublishRelay<Void>()
    let centerItemChanged = PublishRelay<SouvenirListItem>()

    private let disposeBag = DisposeBag()

    // MARK: - Types

    typealias Section = Int
    typealias Item = SouvenirListItem

    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

    private var isProgrammaticScroll = false

    // MARK: - Constants

    enum Metric {
        static let height: CGFloat = 280
        static let cellWidth: CGFloat = 320
        static let cellHeight: CGFloat = 280
        static let cellSpacing: CGFloat = 8
        static let sideInset: CGFloat = 320
    }

    // MARK: - UI

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: makeCVLayout())
        view.backgroundColor = .clear
        view.isScrollEnabled = false
        view.alwaysBounceVertical = false
        view.alwaysBounceHorizontal = false
        view.showsHorizontalScrollIndicator = false
        view.decelerationRate = .fast
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

    func scrollToItem(_ item: Item, animated: Bool = true) {
        guard let indexPath = dataSource?.indexPath(for: item) else { return }

        collectionView.scrollToItem(
            at: indexPath,
            at: .centeredHorizontally,
            animated: animated
        )
    }
}

// MARK: - UI Configuration

private extension SouvenirCarouselView {
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
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(Metric.height)
        }
    }
}

// MARK: - Diffable / CellRegistration

private extension SouvenirCarouselView {
    func configureDataSource() {
        let registration = UICollectionView.CellRegistration<
            SouvenirCarouselCell,
            Item
        > { [weak self] cell, _, item in
            guard let self else { return }

            cell.render(item: item)
            cell.closeButtonTapped
                .bind(to: closeButtonTapped)
                .disposed(by: cell.disposeBag)
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

private extension SouvenirCarouselView {
    func makeCVLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] _, environment in
            guard let self else { return nil }

            let horizontalInset: CGFloat = 20
            let containerWidth = environment.container.effectiveContentSize.width
            let groupWidth = max(0, containerWidth - horizontalInset * 2)

            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(Metric.cellHeight)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .absolute(groupWidth),
                heightDimension: .absolute(Metric.cellHeight)
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitems: [item]
            )

            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPagingCentered
            section.interGroupSpacing = Metric.cellSpacing

            section.visibleItemsInvalidationHandler = { [weak self] visibleItems, point, environment in
                guard let self else { return }

                // 중앙에 가장 가까운 아이템 찾기
                let containerWidth = environment.container.effectiveContentSize.width
                let centerX = point.x + containerWidth / 2

                var closestItem: NSCollectionLayoutVisibleItem?
                var minDistance = CGFloat.greatestFiniteMagnitude

                for item in visibleItems {
                    let distance = abs(item.frame.midX - centerX)
                    if distance < minDistance {
                        minDistance = distance
                        closestItem = item
                    }
                }

                if let closestItem,
                   let item = dataSource?.itemIdentifier(for: closestItem.indexPath) {
                    centerItemChanged.accept(item)
                }
            }

            return section
        }
    }
}

// MARK: - UICollectionView Delegate

extension SouvenirCarouselView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource?.itemIdentifier(for: indexPath) else { return }
        if !isProgrammaticScroll {
            itemTapped.accept(item)
        }
    }
}
