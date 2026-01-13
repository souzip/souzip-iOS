import CoreLocation
import Domain
import Foundation

final class GlobeViewModel: BaseViewModel<
    GlobeState,
    GlobeAction,
    GlobeEvent,
    HomeRoute
> {
    // MARK: - Repository

    private let countryRepo: CountryRepository
    private let souvenirRepo: SouvenirRepository

    // MARK: - Properties

    private let locationManager = CLLocationManager()

    // 카메라 이동 추적
    private var lastKnownCenter: CLLocationCoordinate2D?

    // 현재 기념품 리스트 캐시 (State 업데이트 없이도 유지)
    private var currentSouvenirs: [SouvenirListItem] = []

    // 캐러셀 닫을 때 현재 카메라 위치 저장
    private var lastCarouselCameraCenter: CLLocationCoordinate2D?

    // MARK: - Init

    init(
        countryRepo: CountryRepository,
        souvenirRepo: SouvenirRepository
    ) {
        self.countryRepo = countryRepo
        self.souvenirRepo = souvenirRepo
        super.init(initialState: State())
    }

    // MARK: - Action Handling

    override func handleAction(_ action: Action) {
        switch action {
        case .viewReady:
            break

        case .mapReady:
            handleMapReady()

        case let .wantToSeeCountry(badge):
            handleCountrySelection(badge)

        case .wantToSearchLocation:
            handleSearchTap()

        case .wantToGoMyLocation:
            handleMyLocationTap()

        case let .wantToSeeSouvenirPin(item):
            handleSouvenirPinSelection(item)

        case let .wantToSeeSouvenirDetail(item):
            handleSouvenirDetailSelection(item)

        case .wantToUploadSouvenir:
            navigate(to: .souvenirRoute(.create))

        case .wantToGoBack:
            handleBackTap()

        case .wantToClose:
            handleCloseTap()

        case let .userMovedMap(coordinate):
            handleMapMove(coordinate)

        case let .userTappedSearchInArea(center, radius):
            handleSearchInArea(center: center, radius: radius)

        case let .userChangedSheetLevel(level):
            handleSheetLevelChange(level)

        case let .carouselCenterChanged(item):
            handleCarouselCenterChanged(item)

        case .userClosedCarousel:
            handleCarouselClose()

        case let .didSelectSearchResult(item):
            handleSearchResultSelection(item)
        }
    }
}

// MARK: - Lifecycle

private extension GlobeViewModel {
    func handleMapReady() {
        Task {
            await loadCountryBadges()
        }
    }

    func loadCountryBadges() async {
        let badges = try? countryRepo.fetchCountries()
            .map(CountryBadge.init)

        mutate {
            $0.countryBadges = badges ?? []
        }
    }
}

// MARK: - Scene Transitions

private extension GlobeViewModel {
    func transitionToGlobe() {
        lastKnownCenter = nil
        currentSouvenirs = []

        mutate {
            $0.scene = .globe
            $0.isFromSearch = false
        }

        emit(.renderScene(.globe))
    }

    func transitionToMapWithSheet(
        souvenirs: [SouvenirListItem],
        sheetLevel: SheetLevel,
        center: CLLocationCoordinate2D,
        searchQuery: String?,
        showSearchButton: Bool = false
    ) {
        let context = MapSheetContext(
            souvenirs: souvenirs,
            sheetLevel: sheetLevel,
            center: center,
            searchQuery: searchQuery,
            showSearchButton: showSearchButton
        )

        lastKnownCenter = center
        currentSouvenirs = souvenirs

        mutate {
            $0.scene = .mapWithSheet(context)
        }

        emit(.renderScene(.mapWithSheet(context)))
    }

    func showCarouselScene(
        souvenirs: [SouvenirListItem],
        selectedItem: SouvenirListItem,
        searchQuery: String?
    ) {
        let context = CarouselContext(
            souvenirs: souvenirs,
            selectedItem: selectedItem,
            searchQuery: searchQuery
        )

        mutate {
            $0.scene = .mapWithCarousel(context)
        }

        emit(.renderScene(.mapWithCarousel(context)))
    }

    func updateCarouselSelectedItem(_ item: SouvenirListItem) {
        guard case let .mapWithCarousel(context) = state.value.scene else { return }

        let newContext = CarouselContext(
            souvenirs: context.souvenirs,
            selectedItem: item,
            searchQuery: context.searchQuery
        )

        mutate {
            $0.scene = .mapWithCarousel(newContext)
        }
    }

    // 기념품과 핀만 업데이트 (State 업데이트 X, 이벤트만!)
    func updateSouvenirsAndPinsOnly(_ souvenirs: [SouvenirListItem]) {
        currentSouvenirs = souvenirs
        emit(.updateSouvenirsAndPinsOnly(souvenirs))
    }

    // 검색 버튼만 표시 (State 업데이트 X, 이벤트만)
    func showSearchButtonOnly() {
        emit(.showSearchButton(true))
    }
}

// MARK: - Country Selection

private extension GlobeViewModel {
    func handleCountrySelection(_ badge: CountryBadge) {
        Task {
            let roundedCoordinate = badge.coordinate.rounded(toDecimalPlaces: 2)

            let souvenirs = try await loadSouvenirs(
                near: roundedCoordinate,
                radius: 5000
            )

            transitionToMapWithSheet(
                souvenirs: souvenirs,
                sheetLevel: .mid,
                center: roundedCoordinate,
                searchQuery: badge.countryName
            )
        }
    }
}

// MARK: - Search

private extension GlobeViewModel {
    func handleSearchTap() {
        navigate(
            to: .souvenirRoute(
                .search { [weak self] item in
                    self?.navigate(to: .pop)
                    self?.handleAction(.didSelectSearchResult(item))
                }
            )
        )
    }

    func handleSearchResultSelection(_ item: SearchResultItem) {
        Task {
            let souvenirs = try await loadSouvenirs(
                near: item.coordinate,
                radius: 5000
            )

            transitionToMapWithSheet(
                souvenirs: souvenirs,
                sheetLevel: .mid,
                center: item.coordinate,
                searchQuery: item.name
            )

            mutate {
                $0.isFromSearch = true
            }
        }
    }

    func handleSearchInArea(center: CLLocationCoordinate2D, radius: Double) {
        Task {
            let souvenirs = try await loadSouvenirs(
                near: center,
                radius: Int(radius)
            )

            updateSouvenirsAndPinsOnly(souvenirs)
        }
    }
}

// MARK: - My Location

private extension GlobeViewModel {
    func handleMyLocationTap() {
        let status = locationManager.authorizationStatus

        switch status {
        case .denied, .restricted:
            emit(.showLocationPermissionAlert)

        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()

        case .authorizedAlways, .authorizedWhenInUse:
            moveToUserLocation()

        @unknown default:
            break
        }
    }

    func moveToUserLocation() {
        guard let userLocation = locationManager.location?.coordinate else { return }

        Task {
            let souvenirs = try await loadSouvenirs(
                near: userLocation,
                radius: 500
            )

            switch state.value.scene {
            case .globe:
                transitionToMapWithSheet(
                    souvenirs: souvenirs,
                    sheetLevel: .mid,
                    center: userLocation,
                    searchQuery: nil
                )

            case let .mapWithSheet(context):
                transitionToMapWithSheet(
                    souvenirs: souvenirs,
                    sheetLevel: context.sheetLevel,
                    center: userLocation,
                    searchQuery: context.searchQuery,
                    showSearchButton: false
                )

            case let .mapWithCarousel(context):
                transitionToMapWithSheet(
                    souvenirs: souvenirs,
                    sheetLevel: .mid,
                    center: userLocation,
                    searchQuery: context.searchQuery
                )
            }
        }
    }
}

// MARK: - Map Interaction

private extension GlobeViewModel {
    func handleMapMove(_ coordinate: CLLocationCoordinate2D) {
        guard state.value.mapMode == .map else {
            return
        }

        // 캐러셀 모드일 때 카메라 위치 저장
        if case .mapWithCarousel = state.value.scene {
            lastCarouselCameraCenter = coordinate
        }

        guard let lastCenter = lastKnownCenter else {
            lastKnownCenter = coordinate
            return
        }

        // x축(경도)만 비교
        let hasMoved = coordinate.longitude != lastCenter.longitude

        if hasMoved {
            if case let .mapWithSheet(context) = state.value.scene {
                if !context.showSearchButton {
                    showSearchButtonOnly()
                }
            }

            lastKnownCenter = coordinate
        }
    }
}

// MARK: - Sheet Interaction

private extension GlobeViewModel {
    func handleSheetLevelChange(_ level: SheetLevel) {
        guard case let .mapWithSheet(context) = state.value.scene else { return }

        transitionToMapWithSheet(
            souvenirs: context.souvenirs,
            sheetLevel: level,
            center: context.center,
            searchQuery: context.searchQuery,
            showSearchButton: context.showSearchButton
        )
    }
}

// MARK: - Carousel

private extension GlobeViewModel {
    // 캐러셀 센터 변경 (프로그래밍/사용자 모두)
    func handleCarouselCenterChanged(_ item: SouvenirListItem) {
        guard case .mapWithCarousel = state.value.scene else { return }

        // State 업데이트
        updateCarouselSelectedItem(item)

        // 카메라 이동 & 핀 선택
        emit(.moveCameraAndSelectPin(item))
    }

    func handleCarouselClose() {
        guard case let .mapWithCarousel(context) = state.value.scene else { return }

        // 현재 카메라 위치 사용
        let center = lastCarouselCameraCenter ?? context.selectedItem.coordinate.toCLLocationCoordinate2D

        let sheetContext = MapSheetContext(
            souvenirs: context.souvenirs,
            sheetLevel: .min,
            center: center,
            searchQuery: context.searchQuery,
            showSearchButton: false
        )

        mutate {
            $0.scene = .mapWithSheet(sheetContext)
        }

        // 카메라 이동 없이 Scene만 전환 ⭐
        emit(.transitionToSheetWithoutCamera(sheetContext))

        // 저장된 위치 초기화
        lastCarouselCameraCenter = nil
    }
}

// MARK: - Souvenir Selection

private extension GlobeViewModel {
    // 핀 탭 → 캐러셀 센터만 변경
    func handleSouvenirPinSelection(_ item: SouvenirListItem) {
        let souvenirs = currentSouvenirs
        guard !souvenirs.isEmpty else { return }

        let searchQuery = state.value.searchQuery

        // 현재 Scene에 따라 처리
        switch state.value.scene {
        case .mapWithSheet:
            // Sheet → Carousel로 전환
            showCarouselScene(
                souvenirs: souvenirs,
                selectedItem: item,
                searchQuery: searchQuery
            )

        case .mapWithCarousel:
            // 이미 Carousel이면 아무것도 안 함 (scrollToItem만 호출)
            break

        default:
            break
        }

        // 캐러셀 센터 변경 (scrollToItem 호출 → centerChanged 발생)
        emit(.scrollCarouselToItem(item))
    }

    // 그리드/캐러셀 아이템 탭 → 상세
    func handleSouvenirDetailSelection(_ item: SouvenirListItem) {
        navigate(to: .souvenirRoute(.detail(id: item.id)))
    }
}

// MARK: - Navigation

private extension GlobeViewModel {
    func handleBackTap() {
        if state.value.isFromSearch {
            mutate {
                $0.isFromSearch = false
            }
            handleSearchTap()
            return
        }

        transitionToGlobe()
    }

    func handleCloseTap() {
        transitionToGlobe()
    }
}

// MARK: - Data Loading

private extension GlobeViewModel {
    func loadSouvenirs(
        near coordinate: CLLocationCoordinate2D,
        radius: Int
    ) async throws -> [SouvenirListItem] {
        try await souvenirRepo.getNearbySouvenirs(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude,
            radiusMeter: radius
        )
    }
}
