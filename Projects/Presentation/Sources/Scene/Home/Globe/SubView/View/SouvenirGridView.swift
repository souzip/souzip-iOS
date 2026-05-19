import DesignSystem
import Domain
import RxSwift
import SnapKit
import UIKit

// MARK: - SouvenirGridAction

enum SouvenirGridAction {
    case itemTap(souvenirID: Int)
    case heartTap(souvenirID: Int)
    case tapUpload
    /// 시트 superview 좌표계 누적 translation.y (그래버 팬과 동일)
    case sheetPullBegan
    case sheetPullChanged(translationY: CGFloat)
    case sheetPullEnded
}

// MARK: - SouvenirGridView

final class SouvenirGridView: BaseView<SouvenirGridAction> {
    // MARK: - Types

    private enum SheetPullMetric {
        static let minVerticalTranslation: CGFloat = 2
        static let scrollTopTolerance: CGFloat = 1
    }

    typealias Section = Int
    typealias Item = SouvenirFeedCardItem

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
        view.showsVerticalScrollIndicator = false
        view.bounces = false
        view.alwaysBounceVertical = false
        return view
    }()

    /// 리스트 최상단에서 아래로 당길 때 시트 높이 조절(스크롤 팬과 동시 인식)
    private lazy var collectionSheetPullPan: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handleCollectionSheetPullPan(_:)))
        pan.delegate = self
        pan.cancelsTouchesInView = false
        return pan
    }()

    /// `SouvenirSheetView`의 superview(글로브 루트) — 팬 translation 기준
    private weak var sheetPullTranslationSuperview: UIView?

    private let emptyView = SouvenirEmptyView()

    // MARK: - Data

    private var dataSource: DataSource?
    private var feedCardItems: [SouvenirFeedCardItem] = []

    /// 시트 높이 조절이 실제로 시작된 뒤에만 `sheetPullEnded`를 보내 스냅이 불필요하게 돌지 않게 함
    private var isSheetPullActive = false

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
            .map { .itemTap(souvenirID: $0.id) }

        bind(emptyView.tapUpload)
            .to(.tapUpload)

        collectionView.addGestureRecognizer(collectionSheetPullPan)
    }

    // MARK: - Public

    /// 시트와 동일한 좌표계로 팬 translation을 계산하기 위해 `SouvenirSheetView.superview`를 넘긴다.
    func setSheetPullTranslationSuperview(_ view: UIView?) {
        sheetPullTranslationSuperview = view
    }

    func render(souvenirs items: [SouvenirListItem]) {
        let feedItems = items.map { SouvenirFeedCardItem(listItem: $0) }
        render(feedCardItems: feedItems)
    }

    func render(feedCardItems items: [SouvenirFeedCardItem]) {
        feedCardItems = items
        applyFeedCardSnapshot()
        updateEmptyState(isEmpty: items.isEmpty)
    }

    /// 찜 토글: 보이는 셀은 하트만 즉시 갱신, 스냅샷은 `feedCardItems` 기준으로 맞춘다(delete/insert 없음).
    func updateWishlistHeart(souvenirID: Int, isWishlisted: Bool?) {
        guard let index = feedCardItems.firstIndex(where: { $0.id == souvenirID }) else { return }

        feedCardItems[index] = feedCardItems[index].withWishlisted(isWishlisted)
        updateVisibleHeartAppearance(souvenirID: souvenirID, isWishlisted: isWishlisted)
    }

    // MARK: - Private

    private func applyFeedCardSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(feedCardItems, toSection: 0)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }

    /// Diffable Item은 찜 토글 직후 stale할 수 있어, 표시·액션은 `feedCardItems`를 우선한다.
    private func resolvedFeedCardItem(for item: SouvenirFeedCardItem) -> SouvenirFeedCardItem {
        feedCardItems.first(where: { $0.id == item.id && $0.listSlotID == item.listSlotID }) ?? item
    }

    /// 스냅샷 Item의 `isWishlisted`는 갱신 전 값일 수 있어, indexPath 조회는 **id** 로만 한다.
    private func updateVisibleHeartAppearance(souvenirID: Int, isWishlisted: Bool?) {
        if let dataSource,
           let snapshotItem = dataSource.snapshot().itemIdentifiers(inSection: 0).first(where: { $0.id == souvenirID }),
           let indexPath = dataSource.indexPath(for: snapshotItem),
           let cell = collectionView.cellForItem(at: indexPath) as? SouvenirFeedCardCell {
            cell.updateWishlistAppearance(isWishlisted: isWishlisted)
            return
        }

        for visibleCell in collectionView.visibleCells {
            guard let cardCell = visibleCell as? SouvenirFeedCardCell,
                  let indexPath = collectionView.indexPath(for: visibleCell),
                  let item = dataSource?.itemIdentifier(for: indexPath),
                  item.id == souvenirID
            else { continue }

            cardCell.updateWishlistAppearance(isWishlisted: isWishlisted)
            return
        }
    }

    private func updateEmptyState(isEmpty: Bool) {
        titleLabel.isHidden = isEmpty
        collectionView.isHidden = isEmpty
        emptyView.isHidden = !isEmpty
    }

    private func isCollectionScrolledToTop() -> Bool {
        let top = -collectionView.adjustedContentInset.top
        return collectionView.contentOffset.y <= top + SheetPullMetric.scrollTopTolerance
    }

    @objc private func handleCollectionSheetPullPan(_ gesture: UIPanGestureRecognizer) {
        guard let ref = sheetPullTranslationSuperview else { return }
        let translation = gesture.translation(in: ref)

        switch gesture.state {
        case .began:
            break

        case .changed:
            guard isCollectionScrolledToTop() else { return }
            guard translation.y > SheetPullMetric.minVerticalTranslation else { return }
            if !isSheetPullActive {
                isSheetPullActive = true
                action.accept(.sheetPullBegan)
            }
            action.accept(.sheetPullChanged(translationY: translation.y))

        case .ended, .cancelled:
            guard isSheetPullActive else { return }
            isSheetPullActive = false
            action.accept(.sheetPullEnded)

        default:
            break
        }
    }

    // UIView가 UIGestureRecognizerDelegate 일부를 구현하므로 `override`는 클래스 본문에만 둔다.
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer === collectionSheetPullPan else {
            return super.gestureRecognizerShouldBegin(gestureRecognizer)
        }
        guard sheetPullTranslationSuperview != nil else { return false }
        let velocity = collectionSheetPullPan.velocity(in: self)
        // 수직 드래그만 시트 풀 후보로 잡아 맨 위에서의 가로 스크롤 오인식 완화
        guard abs(velocity.y) >= abs(velocity.x) else { return false }
        return true
    }
}

// MARK: - UIGestureRecognizerDelegate

extension SouvenirGridView: UIGestureRecognizerDelegate {
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        if gestureRecognizer === collectionSheetPullPan,
           otherGestureRecognizer === collectionView.panGestureRecognizer {
            return true
        }
        if gestureRecognizer === collectionView.panGestureRecognizer,
           otherGestureRecognizer === collectionSheetPullPan {
            return true
        }
        return false
    }
}

// MARK: - Diffable / CellRegistration

private extension SouvenirGridView {
    func configureDataSource() {
        let registration = UICollectionView.CellRegistration<
            SouvenirFeedCardCell,
            Item
        > { [weak self] cell, _, item in
            guard let self else { return }
            let resolved = resolvedFeedCardItem(for: item)
            cell.render(item: resolved)
            cell.action
                .map { _ in SouvenirGridAction.heartTap(souvenirID: resolved.id) }
                .bind(to: action)
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
