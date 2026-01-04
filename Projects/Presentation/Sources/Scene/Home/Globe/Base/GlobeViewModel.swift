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
        case .mapReady:
            handleMapReady()

        case let .cameraDidMove(coordinate):
            handleCameraMove(coordinate)

        case let .tapCountryBadge(badge):
            handleCountryBadgeTap(badge)

        case .tapSearch:
            handleSearchTap()

        case .tapBack:
            handleBackButtonTap()

        case .tapClose:
            handleBackButtonTap()

        case .taplocationButton:
            handleLocationButtonTap()

        case let .tapSearchInLocation(center, radius):
            handleSearchInLocationTap(center: center, radius: radius)

        case let .tapSouvenirPin(item):
            handleSouvenirPinTap(item)

        case .tapCarouselClose:
            handleCarouselClose()

        case let .tapSouvenirItem(item):
            handleSouvenirItemTap(item)

        case .tapUpload:
            navigate(to: .souvenirRoute(.create))
        }
    }
}

// MARK: - Map Lifecycle

private extension GlobeViewModel {
    func handleMapReady() {
        Task {
            await loadCountryBadges()
            moveToInitialLocation()
        }
    }

    func loadCountryBadges() async {
        let badges = try? countryRepo.fetchCountries()
            .map(CountryBadge.init)

        mutate {
            $0.countryBadges = badges ?? []
            $0.mapMode = .globe
        }
    }

    func moveToInitialLocation() {
        let initialCoordinate = CLLocationCoordinate2D(latitude: 37.5, longitude: 127.0)
        moveCameraToCoordinate(initialCoordinate)
    }
}

// MARK: - Camera Control

private extension GlobeViewModel {
    func handleCameraMove(_ coordinate: CLLocationCoordinate2D) {
        guard case .map = state.value.mapMode,
              state.value.shouldShowSearchInLocationButton == false
        else { return }

        let hasMovedFromInitialPosition = !isSameCoordinate(
            coordinate,
            state.value.lastGlobeCenter
        )

        mutate {
            $0.lastGlobeCenter = coordinate
            $0.shouldShowSearchInLocationButton = hasMovedFromInitialPosition
        }
    }

    func isSameCoordinate(_ coord1: CLLocationCoordinate2D, _ coord2: CLLocationCoordinate2D) -> Bool {
        let threshold = 0.01
        return abs(coord1.latitude - coord2.latitude) < threshold &&
            abs(coord1.longitude - coord2.longitude) < threshold
    }

    func moveCameraToCoordinate(
        _ coordinate: CLLocationCoordinate2D,
        mode: MapMode? = nil,
        animated: Bool = false,
        extraLift: CGFloat = 0
    ) {
        let targetMode = mode ?? state.value.mapMode // nil이면 현재 state 사용
        let zoom = zoomLevel(for: targetMode)
        emit(
            .moveCamera(
                coordinate: coordinate,
                zoom: zoom,
                animated: animated,
                extraLift: extraLift
            )
        )
    }

    func zoomLevel(for mode: MapMode) -> CGFloat {
        switch mode {
        case .globe:
            1.5
        case .map:
            15
        }
    }
}

// MARK: - Search In Location

private extension GlobeViewModel {
    func handleSearchInLocationTap(center: CLLocationCoordinate2D, radius: Double) {
        mutate { $0.shouldShowSearchInLocationButton = false }

        Task {
            let results = try await souvenirRepo.getNearbySouvenirs(
                latitude: center.latitude,
                longitude: center.longitude,
                radiusMeter: Int(radius)
            )

            mutate {
                $0.souvenirs = results
                $0.shouldShowSearchInLocationButton = false
            }
        }
    }
}

// MARK: - Map Mode Transition

private extension GlobeViewModel {
    func transitionToMapMode(
        coordinate: CLLocationCoordinate2D,
        animated: Bool = true,
        extraLift: CGFloat = 0
    ) {
        let fixedRadius: Double = 500
        Task {
            let results = try await souvenirRepo.getNearbySouvenirs(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude,
                radiusMeter: Int(fixedRadius)
            )

            mutate {
                $0.souvenirs = results
                $0.sheetViewMode = .bottomSheet(results)
            }
        }

        mutate {
            $0.mapMode = .map
        }
        moveCameraToCoordinate(
            coordinate,
            mode: .map,
            animated: animated,
            extraLift: extraLift
        )
    }
}

// MARK: - Badge Interaction

private extension GlobeViewModel {
    func handleCountryBadgeTap(_ badge: CountryBadge) {
        mutate {
            $0.searchResult = badge.countryName
            $0.mapEntrySource = .other
        }
        transitionToMapMode(coordinate: badge.coordinate, animated: true)
        emit(.moveBottomSheetHeight(.mid))
    }
}

// MARK: - Navigation

private extension GlobeViewModel {
    func handleBackButtonTap() {
        let lastPosition = state.value.lastGlobeCenter
        let entrySource = state.value.mapEntrySource

        switch entrySource {
        case .search:
            navigate(
                to: .souvenirRoute(
                    .search { [weak self] item in
                        self?.handleCountrySelected(item)
                    }
                )
            )

        case .other:
            mutate {
                $0.mapMode = .globe
                $0.sheetViewMode = .hide
                $0.shouldShowSearchInLocationButton = false
            }

            moveCameraToCoordinate(lastPosition, mode: .globe)
        }
    }
}

// MARK: - Location Services

private extension GlobeViewModel {
    func handleLocationButtonTap() {
        let status = locationManager.authorizationStatus

        switch status {
        case .denied, .restricted:
            emit(.locationPermissionDenied)

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

        switch state.value.mapMode {
        case .globe:
            mutate {
                $0.mapEntrySource = .other
                $0.searchResult = ""
            }

            transitionToMapMode(
                coordinate: userLocation,
                animated: false,
                extraLift: 150
            )
            emit(.moveBottomSheetHeight(.mid))

        case .map:
            emit(
                .moveCamera(
                    coordinate: userLocation,
                    zoom: nil,
                    animated: true,
                    extraLift: 150
                )
            )
        }
    }
}

// MARK: - Souvenir Interaction

private extension GlobeViewModel {
    func handleSouvenirPinTap(_ item: SouvenirListItem) {
        let items = state.value.souvenirs
        mutate {
            $0.sheetViewMode = .carousel(items)
        }

        emit(.moveCarouselCenter(item))
    }

    func handleCarouselClose() {
        let items = state.value.souvenirs
        mutate {
            $0.sheetViewMode = .bottomSheet(items)
        }

        emit(.moveBottomSheetHeight(.min))
    }

    func handleSouvenirItemTap(_ item: SouvenirListItem) {
        navigate(to: .souvenirRoute(.detail(id: item.id)))
    }
}

// MARK: - Search

private extension GlobeViewModel {
    private func handleSearchTap() {
        navigate(
            to: .souvenirRoute(
                .search { [weak self] item in
                    self?.navigate(to: .pop)
                    self?.handleCountrySelected(item)
                }
            )
        )
    }

    private func handleCountrySelected(_ item: SearchResultItem) {
        mutate {
            $0.searchResult = item.name
            $0.mapEntrySource = .search
        }

        let isAlreadyMapMode = state.value.mapMode == .map

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self else { return }

            if isAlreadyMapMode {
                // 이미 지도 모드 → 카메라만 이동
                moveCameraToCoordinate(
                    item.coordinate,
                    mode: .map, // zoom 15로 이동
                    animated: true,
                    extraLift: 150
                )
            } else {
                // Globe 모드 → 지도 모드로 전환
                transitionToMapMode(
                    coordinate: item.coordinate,
                    animated: false,
                    extraLift: 150
                )
            }

            emit(.moveBottomSheetHeight(.mid))
        }
    }
}
