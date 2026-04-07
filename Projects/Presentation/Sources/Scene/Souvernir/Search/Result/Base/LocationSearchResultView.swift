import CoreLocation
import DesignSystem
import RxRelay
import RxSwift
import SnapKit
import UIKit

final class LocationSearchResultView: BaseView<LocationSearchResultAction> {
    // MARK: - Types

    typealias Section = Int
    typealias Item = SearchResultItem
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

    // MARK: - Sheet Constants

    private enum SheetMetric {
        /// 최소 높이 = 헤더만(51pt). 이때 확인 버튼은 시트 높이상 도저히 보이지 않으며 `masksToBounds`로 잘림.
        /// 중간 높이에서 UX가 어색하면 `currentSheetHeight` 등 기준으로 버튼 숨김·인셋 조정을 별도 검토.
        static let sheetHeaderHeight: CGFloat = 51
        static let minHeight: CGFloat = sheetHeaderHeight
        static let cornerRadius: CGFloat = 20
        /// 시트 상단 고정 영역(초기 시트 높이 계산용, SnapKit과 동일)
        static let chromeAboveList: CGFloat = sheetHeaderHeight
        static let cellHeight: CGFloat = 70
        static let interItemSpacing: CGFloat = 13
        static let confirmButtonHeight: CGFloat = 50
        static let confirmBottomInset: CGFloat = 12
        /// 맨 아래 셀과 확인 버튼 사이
        static let cellAboveButtonGap: CGFloat = 24
        static let searchBarHeight: CGFloat = 51
        static let searchBarBelowNav: CGFloat = 10
        static let sheetBelowSearchBar: CGFloat = 20
        /// DSNavigationBar 높이 제약과 동일
        static let navigationBarHeight: CGFloat = 60
        /// 리스트 최상단에서 시트를 내릴 때, 스크롤과 구분하기 위한 최소 아래 방향 이동량(pt)
        static let sheetPullMinTranslationY: CGFloat = 2
        /// `contentOffset`이 상단에 붙었는지 판별할 때 허용 오차(pt)
        static let scrollTopTolerance: CGFloat = 1
    }

    // MARK: - UI

    private let navigationBar = DSNavigationBar(
        title: "위치 선택",
        style: .back
    )

    private let searchBarView = MapSearchBarView()

    /// 맵이 비치는 영역을 가리기 위해 safe area 상단~네비 하단까지 덮는 배경
    private let navHeaderBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .dsBackground
        view.isUserInteractionEnabled = false
        return view
    }()

    private let mapView: LocationMapView

    private let bottomSheetContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .dsGrey900
        view.layer.cornerRadius = SheetMetric.cornerRadius
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.masksToBounds = true
        return view
    }()

    /// 그래버 영역을 둔 시트 최상단(최소 높이 시에도 `sheetHeaderHeight` 유지)
    private let sheetHeaderView: UIView = {
        let view = UIView()
        // 시트와 동일 배경 — z가 위여도 투명이면 뒤의 버튼이 비쳐 보임
        view.backgroundColor = .dsGrey900
        return view
    }()

    private let grabberView: UIView = {
        let view = UIView()
        view.backgroundColor = .dsGrey500
        view.layer.cornerRadius = 2
        return view
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        // Globe `SouvenirGridView`와 동일 — 끝에서 고무줄 바운스 없음
        cv.bounces = false
        cv.alwaysBounceVertical = false
        return cv
    }()

    /// 리스트 최상단에서 아래로 당길 때 시트 높이 조절(스크롤 팬과 동시 인식)
    private lazy var collectionSheetPullPan: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        pan.delegate = self
        pan.cancelsTouchesInView = false
        return pan
    }()

    private let confirmButton: DSButton = {
        let button = DSButton()
        button.setTitle("선택 완료")
        // DSButton은 setEnabled 시에만 dsMain / dsGreyWhite 스타일이 입혀짐 (Profile·LocationPicker와 동일)
        button.setEnabled(true)
        return button
    }()

    // MARK: - Properties

    private var dataSource: DataSource?
    private var currentSearchText: String = ""
    private var currentSelectedIndex: Int?
    private var currentItems: [SearchResultItem] = []

    // Sheet drag
    private var heightConstraint: Constraint?
    private var panStartHeight: CGFloat = 0
    private var currentSheetHeight: CGFloat = 0
    private var midHeight: CGFloat = 0
    private var maxHeight: CGFloat = 0
    /// `renderPins` 이후 첫 레이아웃에서 초기 시트 높이 1회 적용
    private var pendingApplyInitialSheetHeight = false

    // MARK: - Init

    init(centerCoordinate: CLLocationCoordinate2D) {
        mapView = LocationMapView(mode: .search, initialCoordinate: centerCoordinate)
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Override (BaseView)

    override func setAttributes() {
        backgroundColor = .dsBackground
        configureDataSource()
    }

    override func setHierarchy() {
        [
            mapView,
            navHeaderBackgroundView,
            bottomSheetContainer,
            searchBarView,
            navigationBar,
        ].forEach(addSubview)

        // z순서: 컬렉션(뒤) → 버튼 → 헤더(앞). 헤더가 버튼·리스트와 겹칠 때 덮어서 가림
        bottomSheetContainer.addSubview(collectionView)
        bottomSheetContainer.addSubview(confirmButton)
        bottomSheetContainer.addSubview(sheetHeaderView)
        sheetHeaderView.addSubview(grabberView)
    }

    override func setConstraints() {
        // 맵 풀스크린
        mapView.snp.makeConstraints { make in
            make.top.horizontalEdges.bottom.equalToSuperview()
        }

        // 네비게이션바 오버레이
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }

        navHeaderBackgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(navigationBar.snp.bottom)
        }

        searchBarView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(SheetMetric.searchBarBelowNav)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(SheetMetric.searchBarHeight)
        }

        // 바텀시트 오버레이 (하단 기준)
        bottomSheetContainer.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
            heightConstraint = make.height.equalTo(0).constraint
        }

        sheetHeaderView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(SheetMetric.sheetHeaderHeight)
        }

        grabberView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(9)
            make.centerX.equalToSuperview()
            make.width.equalTo(36.5)
            make.height.equalTo(4)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(sheetHeaderView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        confirmButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(bottomSheetContainer.safeAreaLayoutGuide).inset(SheetMetric.confirmBottomInset)
            make.height.equalTo(SheetMetric.confirmButtonHeight)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        bottomSheetContainer.bringSubviewToFront(sheetHeaderView)
        recalculateSheetHeights()
        updateCollectionContentInsets()
    }

    override func setBindings() {
        bind(navigationBar.onLeftTap).to(.back)

        bind(confirmButton.rx.tap).to(.tapConfirm)

        bind(collectionView.rx.itemSelected)
            .compactMap { [weak self] indexPath -> Action? in
                guard let item = self?.dataSource?.itemIdentifier(for: indexPath),
                      let items = self?.currentItems,
                      let index = items.firstIndex(of: item) else { return nil }
                return .selectItemFromList(index)
            }

        // 시트 높이: 헤더(전 구간) + 리스트는 최상단에서 아래로 당길 때만
        let headerPan = UIPanGestureRecognizer(
            target: self,
            action: #selector(handlePan(_:))
        )
        sheetHeaderView.addGestureRecognizer(headerPan)
        collectionView.addGestureRecognizer(collectionSheetPullPan)

        // 맵 핀 탭: VM 갱신 후 레이아웃·바인딩 다음 틱에 스크롤
        mapView.tapSearchPinRelay
            .subscribe(onNext: { [weak self] index in
                guard let self else { return }
                action.accept(.selectItemFromMap(index))
                DispatchQueue.main.async {
                    self.scrollCollectionToShowItem(at: index)
                }
            })
            .disposed(by: disposeBag)

        searchBarView.onSearchTapped = { [weak self] in
            self?.action.accept(.tapSearchBar)
        }
        searchBarView.onCloseTapped = { [weak self] in
            self?.action.accept(.tapClearSearchBar)
        }
    }

    // MARK: - Public

    func render(items: [SearchResultItem], searchText: String, selectedIndex: Int?) {
        currentItems = items
        currentSearchText = searchText
        currentSelectedIndex = selectedIndex

        if searchText.isEmpty {
            searchBarView.render(mode: .mapEmpty)
        } else {
            searchBarView.render(mode: .mapWithQuery(searchText))
        }

        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(items, toSection: 0)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }

    func updateSelection(selectedIndex: Int?) {
        currentSelectedIndex = selectedIndex
        mapView.selectSearchPin(at: selectedIndex)

        // 모든 셀 reconfigure
        guard let dataSource else { return }
        var snapshot = dataSource.snapshot()
        snapshot.reconfigureItems(snapshot.itemIdentifiers)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    func renderPins(_ items: [SearchResultItem]) {
        mapView.setSearchPins(items)
        pendingApplyInitialSheetHeight = true
    }

    func moveCamera(to coordinate: CLLocationCoordinate2D) {
        mapView.moveCamera(to: coordinate)
    }

    // MARK: - Collection (핀 탭 시에만 스크롤)

    private func scrollCollectionToShowItem(at index: Int) {
        guard currentItems.indices.contains(index) else { return }
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.layoutIfNeeded()
        guard collectionView.numberOfSections > 0,
              collectionView.numberOfItems(inSection: 0) > index else { return }
        collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
    }

    // MARK: - Sheet Height

    private func recalculateSheetHeights() {
        let fullHeight = bounds.height
        guard fullHeight > 0 else { return }

        let searchBarBottom = safeAreaInsets.top
            + SheetMetric.navigationBarHeight
            + SheetMetric.searchBarBelowNav
            + SheetMetric.searchBarHeight

        maxHeight = fullHeight - searchBarBottom - SheetMetric.sheetBelowSearchBar
        maxHeight = max(SheetMetric.minHeight, maxHeight)

        let rawMid = fullHeight * 0.5
        midHeight = min(rawMid, maxHeight)

        if pendingApplyInitialSheetHeight {
            pendingApplyInitialSheetHeight = false
            let initial = computeInitialSheetHeight(itemCount: currentItems.count)
            setSheetHeight(initial, animated: false)
            return
        }

        if currentSheetHeight > maxHeight {
            setSheetHeight(maxHeight, animated: false)
        }
    }

    /// 리스트 순 높이(섹션 인셋 포함), `createLayout`과 동일 규칙
    private func intrinsicListHeight(itemCount: Int) -> CGFloat {
        guard itemCount > 0 else { return 0 }
        let n = CGFloat(itemCount)
        return n * SheetMetric.cellHeight
            + CGFloat(max(0, itemCount - 1)) * SheetMetric.interItemSpacing
    }

    private func listScrollBottomInset() -> CGFloat {
        let safeBottom = max(
            bottomSheetContainer.safeAreaInsets.bottom,
            safeAreaInsets.bottom
        )
        return SheetMetric.cellAboveButtonGap
            + SheetMetric.confirmButtonHeight
            + SheetMetric.confirmBottomInset
            + safeBottom
    }

    private func sheetChromeBelowList() -> CGFloat {
        listScrollBottomInset()
    }

    private func updateCollectionContentInsets() {
        let inset = listScrollBottomInset()
        collectionView.contentInset.bottom = inset
        collectionView.verticalScrollIndicatorInsets.bottom = inset
    }

    /// 스크롤이 필요하면 mid, 아니면 콘텐츠 높이(크롬 포함)
    private func computeInitialSheetHeight(itemCount: Int) -> CGFloat {
        let chromeTop = SheetMetric.chromeAboveList
        let chromeBottom = sheetChromeBelowList()
        let listH = intrinsicListHeight(itemCount: itemCount)
        let visibleListAtMid = midHeight - chromeTop - chromeBottom

        let needsScroll = listH > visibleListAtMid + 0.5
        let contentTotal = chromeTop + chromeBottom + listH

        let target: CGFloat = if needsScroll {
            midHeight
        } else {
            max(SheetMetric.minHeight, contentTotal)
        }
        return max(SheetMetric.minHeight, min(target, maxHeight))
    }

    private func setSheetHeight(_ height: CGFloat, animated: Bool) {
        let clamped = max(SheetMetric.minHeight, min(height, maxHeight))
        currentSheetHeight = clamped
        heightConstraint?.update(offset: clamped)

        let halfScreen = UIScreen.main.bounds.height * 0.5
        let lift = min(clamped / halfScreen * 150, 150)
        mapView.updateCameraPadding(bottom: lift)

        if animated {
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
        } else {
            layoutIfNeeded()
        }
    }

    private func snapSheetToNearest() {
        let candidates = [SheetMetric.minHeight, midHeight, maxHeight]
        let nearest = candidates.min { abs($0 - currentSheetHeight) < abs($1 - currentSheetHeight) } ?? midHeight
        setSheetHeight(nearest, animated: true)
    }

    private func isCollectionScrolledToTop() -> Bool {
        let top = -collectionView.adjustedContentInset.top
        return collectionView.contentOffset.y <= top + SheetMetric.scrollTopTolerance
    }

    // MARK: - Pan Gesture

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let superview else { return }
        let translation = gesture.translation(in: superview)

        switch gesture.state {
        case .began:
            panStartHeight = currentSheetHeight

        case .changed:
            if gesture === collectionSheetPullPan {
                guard isCollectionScrolledToTop() else { return }
                // 위로 당기면 리스트 스크롤에 맡기고, 아래로 당길 때만 시트를 내림
                guard translation.y > SheetMetric.sheetPullMinTranslationY else { return }
            }
            let proposed = panStartHeight - translation.y
            setSheetHeight(proposed, animated: false)

        case .ended, .cancelled:
            snapSheetToNearest()

        default:
            break
        }
    }

    // UIView가 UIGestureRecognizerDelegate 일부를 구현하므로 `override`는 클래스 본문에만 둔다.
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer === collectionSheetPullPan else {
            return super.gestureRecognizerShouldBegin(gestureRecognizer)
        }
        return isCollectionScrolledToTop()
    }

    // MARK: - CollectionView Layout

    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(SheetMetric.cellHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(SheetMetric.cellHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = SheetMetric.interItemSpacing
        section.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)

        return UICollectionViewCompositionalLayout(section: section)
    }

    // MARK: - DataSource

    private func configureDataSource() {
        let cityRegistration = UICollectionView.CellRegistration<
            CitySearchResultCell,
            Item
        > { [weak self] cell, _, item in
            guard let self else { return }
            let isSelected = currentSelectedIndex.map {
                self.currentItems[safe: $0]?.id == item.id
            } ?? false
            cell.render(item: item, searchText: currentSearchText)
            cell.renderSelected(isSelected)
        }

        let placeRegistration = UICollectionView.CellRegistration<
            PlaceSearchResultCell,
            Item
        > { [weak self] cell, _, item in
            guard let self else { return }
            let isSelected = currentSelectedIndex.map {
                self.currentItems[safe: $0]?.id == item.id
            } ?? false
            cell.render(item: item, searchText: currentSearchText)
            cell.renderSelected(isSelected)
        }

        dataSource = .init(collectionView: collectionView) { collectionView, indexPath, item in
            switch item.detail {
            case .city:
                return collectionView.dequeueConfiguredReusableCell(
                    using: cityRegistration,
                    for: indexPath,
                    item: item
                )

            case .place:
                return collectionView.dequeueConfiguredReusableCell(
                    using: placeRegistration,
                    for: indexPath,
                    item: item
                )
            }
        }
    }
}

// MARK: - UIGestureRecognizerDelegate

extension LocationSearchResultView: UIGestureRecognizerDelegate {
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

// MARK: - Helper

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
