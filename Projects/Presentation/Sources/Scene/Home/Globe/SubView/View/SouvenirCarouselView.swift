import Domain
import RxCocoa
import RxSwift
import SnapKit
import UIKit

// MARK: - CarouselItem

private struct CarouselItem: Hashable {
    let index: Int
    let souvenir: SouvenirListItem
}

// MARK: - SouvenirCarouselView

final class SouvenirCarouselView: UIView {
    // MARK: - Action

    let itemTapped = PublishRelay<SouvenirListItem>()
    let closeButtonTapped = PublishRelay<Void>()
    let centerItemChanged = PublishRelay<SouvenirListItem>()

    private let disposeBag = DisposeBag()

    // MARK: - Types

    typealias Section = Int
    private typealias Item = CarouselItem
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

    // MARK: - Constants

    enum Metric {
        static let height: CGFloat = 280
        static let cellHeight: CGFloat = 280
        static let cellSpacing: CGFloat = 8
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
    private var sourceItems: [SouvenirListItem] = []
    private var isScrollingProgrammatically = false

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Public

    func render(items: [SouvenirListItem], selectedItem: SouvenirListItem? = nil) {
        sourceItems = items
        guard !items.isEmpty else { return }

        let count = items.count
        let copies = 100

        var allItems: [Item] = []
        for copy in 0 ..< copies {
            for (i, souvenir) in items.enumerated() {
                allItems.append(Item(index: copy * count + i, souvenir: souvenir))
            }
        }

        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(allItems, toSection: 0)

        isScrollingProgrammatically = true
        dataSource?.apply(snapshot, animatingDifferences: false) { [weak self] in
            guard let self else { return }
            let startCopy = copies / 2
            let itemIndex = selectedItem.flatMap { sel in items.firstIndex(where: { $0.id == sel.id }) } ?? 0
            let startIndex = startCopy * count + itemIndex
            collectionView.scrollToItem(
                at: IndexPath(item: startIndex, section: 0),
                at: .centeredHorizontally,
                animated: false
            )
            DispatchQueue.main.async { self.isScrollingProgrammatically = false }
        }
    }

    func scrollToItem(_ item: SouvenirListItem, animated: Bool = true) {
        guard let sourceIndex = sourceItems.firstIndex(where: { $0.id == item.id }) else { return }

        let count = sourceItems.count
        let total = collectionView.numberOfItems(inSection: 0)
        let midCopy = (total / count) / 2
        let targetIndexPath = IndexPath(item: midCopy * count + sourceIndex, section: 0)

        isScrollingProgrammatically = true
        collectionView.scrollToItem(at: targetIndexPath, at: .centeredHorizontally, animated: animated)

        if animated {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] in
                self?.isScrollingProgrammatically = false
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.isScrollingProgrammatically = false
            }
        }
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

            cell.render(item: item.souvenir)
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
                guard let self, !isScrollingProgrammatically else { return }

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

                guard let closestItem,
                      let carouselItem = dataSource?.itemIdentifier(for: closestItem.indexPath) else { return }

                centerItemChanged.accept(carouselItem.souvenir)
            }

            return section
        }
    }
}

// MARK: - UICollectionView Delegate

extension SouvenirCarouselView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource?.itemIdentifier(for: indexPath) else { return }
        itemTapped.accept(item.souvenir)
    }
}
