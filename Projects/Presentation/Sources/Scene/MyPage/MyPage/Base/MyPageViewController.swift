import DesignSystem
import RxSwift
import SnapKit
import UIKit

final class MyPageViewController: BaseViewController<
    MyPageViewModel,
    MyPageView
>, UICollectionViewDelegate {
    private let collectionTabViewController: MyPageCollectionTabViewController
    private let likedTabViewController: MyPageLikedTabViewController
    private var pagingStripViewController: MyPagePagingStripViewController?

    /// Parchment에서 이미 페이지가 바뀐 뒤 `tapSegmentTab`으로 VM만 맞출 때는 `syncSelection`을 다시 호출하지 않음
    private var isTabChangeFromPagerStrip = false

    private var didAddPagingStripAsChild = false

    init(
        viewModel: MyPageViewModel,
        contentView: MyPageView,
        collectionTabViewController: MyPageCollectionTabViewController,
        likedTabViewController: MyPageLikedTabViewController
    ) {
        self.collectionTabViewController = collectionTabViewController
        self.likedTabViewController = likedTabViewController
        super.init(viewModel: viewModel, contentView: contentView)
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        contentView.rootListView().configure(collectionViewDelegate: self)
        super.viewDidLoad()
        contentView.onRootListSnapshotRendered = { [weak self] in
            self?.schedulePagingHeightRefresh()
        }
        setupPagingStripViewController()
        bindCollectionTabHeightChanges()
        applyInitialPagingSelection()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        refreshPagerSectionLayout()
    }

    // MARK: - Bind

    override func bindState() {
        observeState()
            .map { (isGuest: $0.isGuest, profile: $0.profile) }
            .onNext(contentView.renderRootList)

        observe(\.selectedTab)
            .distinct()
            .onNext { [weak self] tab in
                self?.syncPagingStripForSelectedTab(tab)
            }
    }

    override func handleEvent(_ event: Event) {
        switch event {
        case let .showErrorAlert(message):
            showDSAlert(message: message)
        }
    }

    // MARK: - Paging (Parchment)

    private func setupPagingStripViewController() {
        let strip = MyPagePagingStripViewController(
            collectionPage: collectionTabViewController,
            likedPage: likedTabViewController,
            onTabChange: { [weak self] tab in
                guard let self else { return }
                guard viewModel.state.value.selectedTab != tab else { return }
                isTabChangeFromPagerStrip = true
                viewModel.action.accept(.tapSegmentTab(tab))
                isTabChangeFromPagerStrip = false
            }
        )
        pagingStripViewController = strip
    }

    private func applyInitialPagingSelection() {
        pagingStripViewController?.syncSelection(viewModel.state.value.selectedTab, animated: false)
        schedulePagingHeightRefresh()
    }

    private func bindCollectionTabHeightChanges() {
        viewModel.collectionTabViewModel.state
            .asObservable()
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.schedulePagingHeightRefresh()
            })
            .disposed(by: disposeBag)
    }

    private func schedulePagingHeightRefresh() {
        DispatchQueue.main.async { [weak self] in
            self?.refreshPagerSectionLayout()
            DispatchQueue.main.async { [weak self] in
                self?.refreshPagerSectionLayout()
            }
        }
    }

    private func refreshPagerSectionLayout() {
        let width = resolvePagingLayoutWidth()
        guard width > 0 else { return }
        let newHeight = computePagerHostHeight(layoutWidth: width)
        contentView.rootListView().updatePagerSectionHeight(newHeight)
    }

    private func computePagerHostHeight(layoutWidth: CGFloat) -> CGFloat {
        guard let strip = pagingStripViewController else {
            return Metrics.pagerHostMinimumHeight
        }

        let contentHeight = strip.preferredTotalHeight(for: layoutWidth)
        let profileExtent = profileSectionLayoutExtent()
        let listVisibleHeight = contentView.rootListView().listVisibleHeight()

        let viewportLowerBound: CGFloat = if listVisibleHeight > 1 {
            max(
                0,
                listVisibleHeight - profileExtent - Metrics.listBottomContentInset
            )
        } else {
            0
        }

        return max(
            contentHeight,
            viewportLowerBound,
            Metrics.pagerHostMinimumHeight
        )
    }

    private func profileSectionLayoutExtent() -> CGFloat {
        viewModel.state.value.profile == nil ? 0 : Metrics.profileSectionVerticalExtent
    }

    private func resolvePagingLayoutWidth() -> CGFloat {
        let candidates: [CGFloat] = [
            view.bounds.width,
            contentView.bounds.width,
            contentView.rootListView().listLayoutWidth(),
        ]
        let fromSelf = candidates.max() ?? 0
        if fromSelf > 1 {
            return fromSelf
        }
        if let windowWidth = view.window?.bounds.width, windowWidth > 1 {
            return windowWidth
        }
        return UIScreen.main.bounds.width
    }

    private func attachPagingStripIfNeeded(to host: UIView) {
        guard let strip = pagingStripViewController else { return }
        if strip.view.superview === host {
            return
        }

        strip.view.removeFromSuperview()
        host.addSubview(strip.view)
        strip.view.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }

        if !didAddPagingStripAsChild {
            addChild(strip)
            strip.didMove(toParent: self)
            didAddPagingStripAsChild = true
        }
    }

    private enum Metrics {
        static let listBottomContentInset: CGFloat = 20
        static let pagerHostMinimumHeight: CGFloat = 240
        /// 프로필 섹션 레이아웃(`MyPageRootListLayout` + 헤더)에 대응하는 대략적 세로 길이
        static let profileSectionVerticalExtent: CGFloat = 118
    }

    private func syncPagingStripForSelectedTab(_ tab: CollectionTab) {
        if !isTabChangeFromPagerStrip {
            pagingStripViewController?.syncSelection(tab, animated: false)
        }
        schedulePagingHeightRefresh()
    }
}

// MARK: - UICollectionViewDelegate

extension MyPageViewController {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let item = contentView.rootListView().itemIdentifier(for: indexPath) else { return }
        guard case .pagerHost = item else { return }
        guard let pagerCell = cell as? MyPageRootPagerHostingCell else { return }
        attachPagingStripIfNeeded(to: pagerCell.hostContainerView)
    }
}
