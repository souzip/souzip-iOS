import DesignSystem
import Parchment
import SnapKit
import UIKit

/// Parchment `PagingViewController` 래퍼 (컬렉션 / 찜)
final class MyPagePagingStripViewController: UIViewController {
    private let pagingViewController = PagingViewController()
    private let collectionPage: MyPageCollectionTabViewController
    private let likedPage: MyPageLikedTabViewController
    private let onTabChange: (CollectionTab) -> Void

    init(
        collectionPage: MyPageCollectionTabViewController,
        likedPage: MyPageLikedTabViewController,
        onTabChange: @escaping (CollectionTab) -> Void
    ) {
        self.collectionPage = collectionPage
        self.likedPage = likedPage
        self.onTabChange = onTabChange
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear

        addChild(pagingViewController)
        view.addSubview(pagingViewController.view)
        pagingViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        pagingViewController.didMove(toParent: self)

        pagingViewController.dataSource = self
        pagingViewController.delegate = self

        pagingViewController.menuItemSize = .sizeToFit(minWidth: 72, height: 44)
        pagingViewController.menuInteraction = .swipe
        pagingViewController.menuTransition = .scrollAlongside
        pagingViewController.indicatorOptions = .visible(
            height: 1,
            zIndex: Int.max,
            spacing: .zero
        )
        pagingViewController.indicatorColor = .dsGreyWhite
        pagingViewController.borderOptions = .visible(
            height: 1,
            zIndex: Int.max - 1,
            insets: .zero
        )
        pagingViewController.borderColor = .dsGrey500
        pagingViewController.textColor = .dsGrey700
        pagingViewController.selectedTextColor = .dsGreyWhite
        pagingViewController.font = .pretendard(size: 16, weight: .semiBold)
        pagingViewController.selectedFont = .pretendard(size: 16, weight: .semiBold)
        pagingViewController.menuBackgroundColor = .dsBackground
        pagingViewController.backgroundColor = .dsBackground
        pagingViewController.selectedBackgroundColor = .dsBackground

        pagingViewController.select(index: CollectionTab.collection.pageIndex, animated: false)
    }

    func syncSelection(_ tab: CollectionTab, animated: Bool) {
        // 루트 리스트에서 호스트 셀 `willDisplay` 전에 호출될 수 있음 — `viewDidLoad`에서 `dataSource` 설정
        loadViewIfNeeded()

        let targetIndex = tab.pageIndex
        if let current = pagingViewController.state.currentPagingItem as? PagingIndexItem,
           current.index == targetIndex {
            return
        }
        pagingViewController.select(index: targetIndex, animated: animated)
    }

    /// 메뉴 + 페이지 본문을 합친 높이 (루트 리스트 페이저 호스트 셀 높이 산정용)
    func preferredTotalHeight(for layoutWidth: CGFloat) -> CGFloat {
        loadViewIfNeeded()

        let safeWidth = max(layoutWidth, 1)
        pagingViewController.view.layoutIfNeeded()
        let rawMenu = pagingViewController.collectionView.bounds.height
        let menuHeight = rawMenu > 1 ? rawMenu : 44
        let bodyMax = max(
            collectionPage.preferredBodyHeight(for: safeWidth),
            likedPage.preferredBodyHeight(for: safeWidth)
        )
        return menuHeight + max(bodyMax, 1)
    }

    private func notifyTabChangeIfNeeded(pagingItem: PagingItem) {
        guard let item = pagingItem as? PagingIndexItem else { return }
        guard let tab = CollectionTab(pageIndex: item.index) else { return }
        onTabChange(tab)
    }
}

extension MyPagePagingStripViewController: PagingViewControllerDataSource {
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        2
    }

    func pagingViewController(
        _: PagingViewController,
        pagingItemAt index: Int
    ) -> PagingItem {
        guard let tab = CollectionTab(pageIndex: index) else {
            return PagingIndexItem(index: index, title: "")
        }
        return PagingIndexItem(index: index, title: tab.title)
    }

    func pagingViewController(
        _: PagingViewController,
        viewControllerAt index: Int
    ) -> UIViewController {
        switch index {
        case 1:
            likedPage
        default:
            collectionPage
        }
    }
}

extension MyPagePagingStripViewController: PagingViewControllerDelegate {
    func pagingViewController(
        _: PagingViewController,
        didScrollToItem pagingItem: PagingItem,
        startingViewController: UIViewController?,
        destinationViewController: UIViewController,
        transitionSuccessful: Bool
    ) {
        guard transitionSuccessful else { return }
        notifyTabChangeIfNeeded(pagingItem: pagingItem)
    }

    func pagingViewController(
        _: PagingViewController,
        didSelectItem pagingItem: PagingItem
    ) {
        notifyTabChangeIfNeeded(pagingItem: pagingItem)
    }
}
