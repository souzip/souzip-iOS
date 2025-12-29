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
        view.render(with: .globe)
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

        var titleAttr = AttributedString("현 지도에서 검색")
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
    private var mapViewTopConstraint: Constraint?

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
            mapViewTopConstraint = make.top.equalToSuperview().constraint
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        currentLocationButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            self.currentLocationButtonBottomConstraint = make.bottom.equalToSuperview().inset(12).constraint
            make.size.equalTo(42)
        }

        searchInLocationButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            self.searchInLocationButtonBottomConstraint = make.bottom.equalToSuperview().inset(12).constraint
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
        bindSearch()

        bind(currentLocationButton.rx.tap).to(.taplocationButton)

        // 현 지도에서 검색: center + radius 전달
        searchInLocationButton.rx.tap
            .bind { [weak self] in
                guard let self else { return }

                let mapArea = getCurrentMapArea()
                action.accept(.tapSearchInLocation(
                    center: mapArea.center,
                    radius: mapArea.radius
                ))
            }
            .disposed(by: disposeBag)

        souvenirSheetView.heightRelay
            .bind { [weak self] height in
                guard let self, !souvenirSheetView.isHidden else { return }

                let bottomInset = 12 + height
                updateLocationButtonPosition(bottomInset: bottomInset)
                updateSearchInLocationButtonPosition(bottomInset: bottomInset)
                updateCameraForSheet(height: height)
            }
            .disposed(by: disposeBag)
    }

    private func bindMapContainer() {
        bind(mapContainerView.mapReady.asObservable())
            .to(.mapReady)

        bind(
            mapContainerView.cameraDidMove.asObservable()
//                .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
        )
        .map { Action.cameraDidMove($0) }

        bind(mapContainerView.tapCountrybadge.asObservable())
            .map { Action.tapCountryBadge($0) }

        bind(mapContainerView.tapSouvenirPin.asObservable())
            .map { Action.tapSouvenirPin($0) }
    }

    private func bindCarousel() {
        bind(souvenirCarouselView.itemTapped.asObservable())
            .map { Action.tapSouvenirItem($0) }

        bind(souvenirCarouselView.closeButtonTapped.asObservable())
            .map { Action.tapCarouselClose }

        souvenirCarouselView.centerItemChanged
            .distinctUntilChanged()
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
            .bind { [weak self] item in
                guard let self else { return }

                moveCamera(
                    coordinate: item.coordinate.toCLLocationCoordinate2D,
                    zoom: nil,
                    animated: false,
                    extraLift: 150
                )
                mapContainerView.selectSouvenirPin(item: item)
            }
            .disposed(by: disposeBag)
    }

    private func bindSearch() {
        searchBarView.onSearchTapped = { [weak self] in
            self?.action.accept(.tapSearch)
        }

        searchBarView.onBackTapped = { [weak self] in
            self?.action.accept(.tapBack)
        }

        searchBarView.onCloseTapped = { [weak self] in
            self?.action.accept(.tapClose)
        }
    }

    // MARK: - Render

    func renderCountryBadges(_ badges: [CountryBadge]) {
        mapContainerView.setCountryBadges(badges)
    }

    func renderSouvenirPins(_ souvenirs: [SouvenirListItem]) {
        mapContainerView.setSouvenirPins(souvenirs)
    }

    func renderMapMode(_ mode: MapMode) {
        switch mode {
        case .globe:
            mapContainerView.configureAsGlobe()
            mapContainerView.showCountryBadges(isHidden: false)
            mapContainerView.showUserLocation(isHidden: true)
            mapContainerView.showSouvenirPins(isHidden: true)
            searchBarView.render(with: .globe)

        case .map:
            mapContainerView.configureAsMap()
            mapContainerView.showCountryBadges(isHidden: true)
            mapContainerView.showUserLocation(isHidden: false)
            mapContainerView.showSouvenirPins(isHidden: false)
        }
    }

    func renderSheetViewMode(_ mode: SheetViewMode) {
        switch mode {
        case let .bottomSheet(items):
            souvenirSheetView.renderGrid(items)
        case let .carousel(items):
            souvenirCarouselView.render(items: items)
        case .hide:
            hideAllSheet()
        }
    }

    func renderSearchInLocation(isVisible: Bool) {
        searchInLocationButton.isHidden = !isVisible
    }

    func renderCarouselView(_ items: [SouvenirListItem]) {
        souvenirCarouselView.render(items: items)
    }

    func renderSearchView(_ name: String?) {
        guard let name else {
            searchBarView.render(with: .globe)
            return
        }

        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            searchBarView.render(with: .globeBack)
            return
        }

        searchBarView.render(with: .map(locationName: name))
    }

    // MARK: - Event

    func moveCarouselCenter(_ item: SouvenirListItem) {
        hideAllSheet()

        updateLocationButtonPosition(
            bottomInset: 12 + SouvenirCarouselView.Metric.height + 9
        )
        souvenirCarouselView.scrollToItem(item)
        souvenirCarouselView.isHidden = false
    }

    func moveBottomSheetHeight(_ level: BottomSheetLevel) {
        hideAllSheet()

        updateLocationButtonPosition(bottomInset: 21)
        souvenirSheetView.isHidden = false
        souvenirSheetView.setLevel(level)
    }

    func hideAllSheet() {
        updateLocationButtonPosition(bottomInset: 12)
        souvenirCarouselView.isHidden = true
        souvenirSheetView.isHidden = true
        mapContainerView.deselectAllSouvenirPins()
    }

    func moveCamera(
        coordinate: CLLocationCoordinate2D? = nil,
        zoom: CGFloat? = nil,
        animated: Bool,
        duration: TimeInterval = 0.5,
        extraLift: CGFloat = 0
    ) {
        mapContainerView.moveCamera(
            to: coordinate,
            zoom: zoom,
            animated: animated,
            duration: duration,
            extraLift: extraLift
        )
    }

    // MARK: - Private

    private func updateLocationButtonPosition(bottomInset: CGFloat) {
        currentLocationButtonBottomConstraint?.update(inset: bottomInset)

        // 일정 높이 기준으로 숨김/표시
        let threshold = max(bounds.height * 0.6, 200)
        let shouldHide = bottomInset > threshold

        currentLocationButton.alpha = shouldHide ? 0 : 1
        layoutIfNeeded()
    }

    private func updateSearchInLocationButtonPosition(bottomInset: CGFloat) {
        searchInLocationButtonBottomConstraint?.update(inset: bottomInset)

        let threshold = max(bounds.height * 0.6, 200)
        let shouldHide = bottomInset > threshold

        searchInLocationButton.alpha = shouldHide ? 0 : 1
        layoutIfNeeded()
    }

    private func updateCameraForSheet(height: CGFloat) {
        let screenHeight = UIScreen.main.bounds.height
        let halfHeight = screenHeight * 0.5
        let lift = min(height / halfHeight * 150, 150)

        UIView.animate(withDuration: 0.3) {
            self.mapContainerView.updateCameraPadding(extraLift: lift)
        }
    }

    // 현재 지도 영역 정보 가져오기
    private func getCurrentMapArea() -> (center: CLLocationCoordinate2D, radius: Double) {
        let center = mapContainerView.getCurrentCenter()
        let radius = mapContainerView.getCurrentSearchRadius()
        return (center, radius)
    }

    // 조회반경만 가져오기
    private func getCurrentSearchRadius() -> Double {
        mapContainerView.getCurrentSearchRadius()
    }
}
