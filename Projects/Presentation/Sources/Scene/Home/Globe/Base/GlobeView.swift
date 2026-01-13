import CoreLocation
import DesignSystem
import Domain
import RxSwift
import SnapKit
import UIKit

final class GlobeView: BaseView<GlobeAction> {
    // MARK: - UI Components

    private let mapContainerView = MapboxView()

    private let searchBarView: MapSearchBarView = {
        let view = MapSearchBarView()
        view.render(mode: .globe)
        return view
    }()

    private let currentLocationButton: UIButton = {
        var config = UIButton.Configuration.plain()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20)
        config.image = .dsIconLocationTargetActive.withConfiguration(imageConfig)
        config.background.backgroundColor = .dsBackground
        config.cornerStyle = .capsule

        let button = UIButton(configuration: config)
        button.layer.shadowColor = UIColor.dsGreyWhite.cgColor
        button.layer.shadowOpacity = 0.15
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.shadowRadius = 5
        button.layer.masksToBounds = false
        return button
    }()

    private let searchInLocationButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .dsMain
        config.baseForegroundColor = .dsGreyWhite
        config.cornerStyle = .capsule

        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24)
        config.image = .dsIconSearch
        config.imagePadding = 10
        config.imagePlacement = .leading

        config.setTypography(.body2R, title: "현 지도에서 검색")
        config.contentInsets = .init(top: 10, leading: 20, bottom: 10, trailing: 20)

        let button = UIButton(configuration: config)
        button.isHidden = true
        return button
    }()

    private let souvenirCarouselView: SouvenirCarouselView = {
        let view = SouvenirCarouselView()
        view.isHidden = true
        return view
    }()

    private let souvenirSheetView: SouvenirSheetView = {
        let view = SouvenirSheetView()
        view.isHidden = true
        return view
    }()

    // MARK: - Properties

    private var currentLocationButtonBottomConstraint: Constraint?
    private var searchInLocationButtonBottomConstraint: Constraint?

    // MARK: - Override

    override func setAttributes() {
        backgroundColor = .clear
    }

    override func setHierarchy() {
        [
            mapContainerView,
            currentLocationButton,
            searchInLocationButton,
            souvenirCarouselView,
            souvenirSheetView,
            searchBarView,
        ].forEach(addSubview)
    }

    override func setConstraints() {
        mapContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        currentLocationButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            currentLocationButtonBottomConstraint = make.bottom.equalToSuperview().inset(12).constraint
            make.size.equalTo(42)
        }

        searchInLocationButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            searchInLocationButtonBottomConstraint = make.bottom.equalToSuperview().inset(12).constraint
            make.height.equalTo(44)
        }

        souvenirCarouselView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(9)
            make.height.equalTo(280)
        }

        souvenirSheetView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        searchBarView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(12)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(51)
        }
    }

    override func setBindings() {
        bindMapContainer()
        bindCarousel()
        bindSheet()
        bindSearchBar()
        bindButtons()
    }

    private func bindMapContainer() {
        bind(mapContainerView.mapReady.asObservable())
            .to(.mapReady)

        // 카메라 이동 시 debounce 적용 (0.3초 동안 멈췄을 때만)
        mapContainerView.cameraDidMove
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .map { .userMovedMap($0) }
            .bind(to: action)
            .disposed(by: disposeBag)

        bind(mapContainerView.tapCountrybadge.asObservable())
            .map { .wantToSeeCountry($0) }

        // 핀 탭 → 캐러셀 센터 변경
        bind(mapContainerView.tapSouvenirPin.asObservable())
            .map { .wantToSeeSouvenirPin($0) }
    }

    private func bindCarousel() {
        // 캐러셀 아이템 탭 → 상세
        bind(souvenirCarouselView.itemTapped.asObservable())
            .map { .wantToSeeSouvenirDetail($0) }

        bind(souvenirCarouselView.closeButtonTapped.asObservable())
            .map { .userClosedCarousel }

        // 캐러셀 센터 변경 (프로그래밍/사용자 모두)
        souvenirCarouselView.centerItemChanged
            .distinctUntilChanged { $0.id == $1.id }
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
            .bind { [weak self] item in
                self?.action.accept(.carouselCenterChanged(item))
            }
            .disposed(by: disposeBag)
    }

    private func bindSheet() {
        // 시트 그리드 아이템 탭 → 상세
        souvenirSheetView.tapSouvenirItem
            .map { .wantToSeeSouvenirDetail($0) }
            .bind(to: action)
            .disposed(by: disposeBag)

        souvenirSheetView.tapUpload
            .map { .wantToUploadSouvenir }
            .bind(to: action)
            .disposed(by: disposeBag)

        souvenirSheetView.heightRelay
            .bind { [weak self] height in
                self?.updateForSheetHeight(height)
            }
            .disposed(by: disposeBag)
    }

    private func bindSearchBar() {
        searchBarView.onSearchTapped = { [weak self] in
            self?.action.accept(.wantToSearchLocation)
        }

        searchBarView.onCloseTapped = { [weak self] in
            self?.action.accept(.wantToClose)
        }
    }

    private func bindButtons() {
        bind(currentLocationButton.rx.tap)
            .to(.wantToGoMyLocation)

        searchInLocationButton.rx.tap
            .bind { [weak self] in
                guard let self else { return }
                let center = mapContainerView.getCurrentCenter()
                let radius = mapContainerView.getCurrentSearchRadius()
                action.accept(.userTappedSearchInArea(center: center, radius: radius))
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Scene Rendering

extension GlobeView {
    func render(scene: GlobeScene, animated: Bool) {
        switch scene {
        case .globe:
            renderGlobeScene(animated: animated)

        case let .mapWithSheet(context):
            renderMapSheetScene(context, animated: animated)

        case let .mapWithCarousel(context):
            renderCarouselScene(context, animated: animated)
        }
    }

    // Sheet 전환 (카메라 이동 없음)
    func transitionToSheetWithoutCamera(_ context: MapSheetContext) {
        souvenirCarouselView.isHidden = true
        souvenirSheetView.isHidden = false
        searchInLocationButton.isHidden = !context.showSearchButton
        updateLocationButtonPosition(bottomInset: 12)

        if let query = context.searchQuery, !query.isEmpty {
            searchBarView.render(mode: .mapWithQuery(query))
        } else {
            searchBarView.render(mode: .mapEmpty)
        }

        mapContainerView.deselectAllSouvenirPins()
        souvenirSheetView.renderGrid(context.souvenirs)
        souvenirSheetView.setLevel(context.sheetLevel, animated: true)
    }

    // 캐러셀 스크롤 (프로그래밍 방식)
    func scrollCarouselToItem(_ item: SouvenirListItem) {
        souvenirCarouselView.scrollToItem(item)
        mapContainerView.selectSouvenirPin(item: item)
    }

    // 카메라 이동 & 핀 선택
    func moveCameraAndSelectPin(_ item: SouvenirListItem) {
        mapContainerView.moveCamera(
            to: item.coordinate.toCLLocationCoordinate2D,
            zoom: nil,
            animated: false,
            duration: 0.3,
            extraLift: 150
        )
        mapContainerView.selectSouvenirPin(item: item)
    }

    // 검색 버튼만 표시/숨김
    func showSearchButton(_ show: Bool) {
        searchInLocationButton.isHidden = !show
    }

    // 기념품과 핀만 업데이트
    func updateSouvenirsAndPinsOnly(_ souvenirs: [SouvenirListItem]) {
        mapContainerView.setSouvenirPins(souvenirs)
        souvenirSheetView.renderGrid(souvenirs)
        searchInLocationButton.isHidden = true
    }

    private func renderGlobeScene(animated: Bool) {
        hideAllSheets()
        searchInLocationButton.isHidden = true
        updateLocationButtonPosition(bottomInset: 12)
        searchBarView.render(mode: .globe)

        mapContainerView.configureAsGlobe()
        mapContainerView.showCountryBadges(isHidden: false)
        mapContainerView.showUserLocation(isHidden: true)
        mapContainerView.showSouvenirPins(isHidden: true)

        let currentCenter = mapContainerView.getCurrentCenter()
        mapContainerView.moveCamera(
            to: currentCenter,
            zoom: 1.5,
            animated: animated,
            duration: 0.5,
            extraLift: 0
        )
    }

    private func renderMapSheetScene(
        _ context: MapSheetContext,
        animated: Bool
    ) {
        souvenirCarouselView.isHidden = true
        souvenirSheetView.isHidden = false
        searchInLocationButton.isHidden = !context.showSearchButton
        updateLocationButtonPosition(bottomInset: 12)

        if let query = context.searchQuery, !query.isEmpty {
            searchBarView.render(mode: .mapWithQuery(query))
        } else {
            searchBarView.render(mode: .mapEmpty)
        }

        mapContainerView.configureAsMap()
        mapContainerView.showCountryBadges(isHidden: true)
        mapContainerView.showUserLocation(isHidden: false)
        mapContainerView.showSouvenirPins(isHidden: false)
        mapContainerView.setSouvenirPins(context.souvenirs)
        mapContainerView.deselectAllSouvenirPins()

        souvenirSheetView.renderGrid(context.souvenirs)
        souvenirSheetView.setLevel(context.sheetLevel, animated: animated)

        let extraLift: CGFloat = context.sheetLevel == .mid ? 150 : 0
        mapContainerView.moveCamera(
            to: context.center,
            zoom: 10.5,
            animated: animated,
            duration: 0.5,
            extraLift: extraLift
        )
    }

    private func renderCarouselScene(
        _ context: CarouselContext,
        animated: Bool
    ) {
        souvenirSheetView.isHidden = true
        souvenirCarouselView.isHidden = false
        searchInLocationButton.isHidden = true

        let bottomInset: CGFloat = 12 + SouvenirCarouselView.Metric.height + 9
        updateLocationButtonPosition(bottomInset: bottomInset)

        if let query = context.searchQuery, !query.isEmpty {
            searchBarView.render(mode: .mapWithQuery(query))
        } else {
            searchBarView.render(mode: .mapEmpty)
        }

        mapContainerView.configureAsMap()
        mapContainerView.showCountryBadges(isHidden: true)
        mapContainerView.showUserLocation(isHidden: false)
        mapContainerView.showSouvenirPins(isHidden: false)
        mapContainerView.setSouvenirPins(context.souvenirs)

        souvenirCarouselView.render(items: context.souvenirs)
        // scrollToItem은 별도 이벤트로 처리
    }
}

// MARK: - Public Render Methods

extension GlobeView {
    func renderCountryBadges(_ badges: [CountryBadge]) {
        mapContainerView.setCountryBadges(badges)
        renderGlobeScene(animated: true)
        mapContainerView.moveCamera(
            to: .init(latitude: 37.5, longitude: 127.0),
            animated: false,
            duration: 0.3
        )
    }
}

// MARK: - Private Helpers

private extension GlobeView {
    func hideAllSheets() {
        souvenirCarouselView.isHidden = true
        souvenirSheetView.isHidden = true
        mapContainerView.deselectAllSouvenirPins()
    }

    func updateLocationButtonPosition(bottomInset: CGFloat) {
        currentLocationButtonBottomConstraint?.update(inset: bottomInset)

        let threshold = max(bounds.height * 0.6, 200)
        let shouldHide = bottomInset > threshold

        currentLocationButton.alpha = shouldHide ? 0 : 1
        layoutIfNeeded()
    }

    func updateSearchInLocationButtonPosition(bottomInset: CGFloat) {
        searchInLocationButtonBottomConstraint?.update(inset: bottomInset)

        let threshold = max(bounds.height * 0.6, 200)
        let shouldHide = bottomInset > threshold

        searchInLocationButton.alpha = shouldHide ? 0 : 1
        layoutIfNeeded()
    }

    func updateForSheetHeight(_ height: CGFloat) {
        guard !souvenirSheetView.isHidden else { return }

        let bottomInset = 12 + height
        updateLocationButtonPosition(bottomInset: bottomInset)
        updateSearchInLocationButtonPosition(bottomInset: bottomInset)

        let screenHeight = UIScreen.main.bounds.height
        let halfHeight = screenHeight * 0.5
        let lift = min(height / halfHeight * 150, 150)

        mapContainerView.updateCameraPadding(extraLift: lift)
    }
}
