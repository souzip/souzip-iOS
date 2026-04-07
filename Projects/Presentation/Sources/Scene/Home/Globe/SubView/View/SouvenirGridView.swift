import DesignSystem
import Domain
import RxSwift
import SnapKit
import UIKit

// MARK: - SouvenirGridAction

enum SouvenirGridAction {
    case itemTap(SouvenirListItem)
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
            .map { .itemTap($0) }

        bind(emptyView.tapUpload)
            .to(.tapUpload)

        collectionView.addGestureRecognizer(collectionSheetPullPan)
    }

    // MARK: - Public

    /// 시트와 동일한 좌표계로 팬 translation을 계산하기 위해 `SouvenirSheetView.superview`를 넘긴다.
    func setSheetPullTranslationSuperview(_ view: UIView?) {
        sheetPullTranslationSuperview = view
    }

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
