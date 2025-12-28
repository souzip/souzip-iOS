// Presentation/Discovery/GlobeViewModel.swift

import CoreLocation
import Domain
import Foundation

final class GlobeViewModel: BaseViewModel<
    GlobeState,
    GlobeAction,
    GlobeEvent,
    HomeRoute
> {
    // MARK: - Properties

    private let locationManager = CLLocationManager()

    // MARK: - Init

    init() {
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
            return

        case .tapBack:
            handleBackButtonTap()

        case .tapClose:
            return

        case .taplocationButton:
            handleLocationButtonTap()

        case let .tapSouvenirPin(item):
            handleSouvenirPinTap(item)

        case .tapCarouselClose:
            handleCarouselClose()

        case let .tapSouvenirItem(item):
            handleSouvenirItemTap(item)
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
        let badges = CountryBadge.mockData
        mutate {
            $0.countryBadges = badges
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
        guard case .map = state.value.mapMode else { return }

        mutate {
            $0.lastGlobeCenter = coordinate
        }
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

// MARK: - Map Mode Transition

private extension GlobeViewModel {
    func transitionToMapMode(
        coordinate: CLLocationCoordinate2D,
        animated: Bool = true,
        extraLift: CGFloat = 0
    ) {
        let souvenirs = SouvenirMockData.createMockSouvenirs()
        mutate {
            $0.mapMode = .map
            $0.souvenirs = souvenirs
            $0.sheetViewMode = .bottomSheet(souvenirs)
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
        transitionToMapMode(coordinate: badge.coordinate, animated: true)
        emit(.moveBottomSheetHeight(.mid))
    }
}

// MARK: - Navigation

private extension GlobeViewModel {
    func handleBackButtonTap() {
        let lastPosition = state.value.lastGlobeCenter
        mutate {
            $0.mapMode = .globe
            $0.sheetViewMode = .hide
        }
        moveCameraToCoordinate(lastPosition, mode: .globe)
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
        // TODO: Navigate to detail screen
        print("Tapped souvenir item: \(item.name)")
    }
}
