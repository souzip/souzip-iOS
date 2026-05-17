import DesignSystem
import SnapKit
import UIKit

/// 루트 세로 리스트. 페이저 섹션 **높이 숫자**는 VC가 계산해 `updatePagerSectionHeight`로 전달한다(옵션 A).
final class MyPageRootListView: UIView {
    private lazy var collectionView: UICollectionView = {
        let placeholderLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: placeholderLayout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()

    private var dataSource: UICollectionViewDiffableDataSource<MyPageRootSection, MyPageRootItem>?
    private var cachedPagerHostHeight: CGFloat = 400
    private var didConfigure = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUp() {
        backgroundColor = .clear
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    /// Diffable·레이아웃·delegate 1회 구성
    func configure(collectionViewDelegate: UICollectionViewDelegate) {
        guard !didConfigure else { return }
        didConfigure = true

        cachedPagerHostHeight = 400

        let layout = MyPageRootListLayout.makeLayout(
            sectionResolver: { [weak self] sectionIndex in
                guard let self, let dataSource = self.dataSource else {
                    return nil
                }
                let identifiers = dataSource.snapshot().sectionIdentifiers
                guard sectionIndex < identifiers.count else {
                    return nil
                }
                return identifiers[sectionIndex]
            },
            pagerHeight: { [weak self] in
                self?.cachedPagerHostHeight ?? 400
            }
        )
        collectionView.setCollectionViewLayout(layout, animated: false)

        let profileRegistration = UICollectionView.CellRegistration<
            MyPageRootProfileCell,
            ProfileData
        > { cell, _, profile in
            cell.render(profile)
        }

        let pagerRegistration = UICollectionView.CellRegistration<
            MyPageRootPagerHostingCell,
            Bool
        > { _, _, _ in }

        dataSource = UICollectionViewDiffableDataSource<MyPageRootSection, MyPageRootItem>(
            collectionView: collectionView
        ) { collectionView, indexPath, item in
            switch item {
            case let .profile(profile):
                collectionView.dequeueConfiguredReusableCell(
                    using: profileRegistration,
                    for: indexPath,
                    item: profile
                )

            case .pagerHost:
                collectionView.dequeueConfiguredReusableCell(
                    using: pagerRegistration,
                    for: indexPath,
                    item: true
                )
            }
        }

        collectionView.delegate = collectionViewDelegate
        collectionView.contentInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: Metrics.listBottomContentInset,
            right: 0
        )
        collectionView.collectionViewLayout.invalidateLayout()
    }

    func applySnapshot(
        _ input: (isGuest: Bool, profile: ProfileData?),
        animatingDifferences: Bool
    ) {
        var snapshot = NSDiffableDataSourceSnapshot<MyPageRootSection, MyPageRootItem>()

        if input.isGuest {
            dataSource?.apply(snapshot, animatingDifferences: animatingDifferences)
            return
        }

        if let profile = input.profile {
            snapshot.appendSections([.profile, .pager])
            snapshot.appendItems([.profile(profile)], toSection: .profile)
            snapshot.appendItems([.pagerHost], toSection: .pager)
        } else {
            snapshot.appendSections([.pager])
            snapshot.appendItems([.pagerHost], toSection: .pager)
        }

        dataSource?.apply(snapshot, animatingDifferences: animatingDifferences)
    }

    /// VC가 `preferredTotalHeight` 등으로 산출한 값을 전달 — 변경 시에만 레이아웃 무효화
    func updatePagerSectionHeight(_ height: CGFloat) {
        guard abs(height - cachedPagerHostHeight) > 0.5 else { return }
        cachedPagerHostHeight = height
        collectionView.collectionViewLayout.invalidateLayout()
    }

    func itemIdentifier(for indexPath: IndexPath) -> MyPageRootItem? {
        dataSource?.itemIdentifier(for: indexPath)
    }

    func listVisibleHeight() -> CGFloat {
        collectionView.bounds.height
    }

    func listLayoutWidth() -> CGFloat {
        collectionView.bounds.width
    }

    private enum Metrics {
        static let listBottomContentInset: CGFloat = 20
    }
}
