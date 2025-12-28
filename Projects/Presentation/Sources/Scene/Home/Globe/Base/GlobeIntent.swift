import CoreLocation
import Domain

// MARK: - Action

enum GlobeAction {
    case mapReady
    case cameraDidMove(CLLocationCoordinate2D)

    case tapCountryBadge(CountryBadge)
    case taplocationButton

    case tapSearch
    case tapBack
    case tapClose

    case tapSouvenirPin(SouvenirListItem)
    case tapCarouselClose

    case tapSouvenirItem(SouvenirListItem)
}

// MARK: - State

struct GlobeState {
    var mapMode: MapMode = .globe
    var lastGlobeCenter: CLLocationCoordinate2D = .init(latitude: 0, longitude: 0)
    var countryBadges: [CountryBadge] = []

    var sheetViewMode: SheetViewMode = .hide
    var souvenirs: [SouvenirListItem] = []

    var isBackButtonVisible: Bool { mapMode == .map }
}

enum MapMode: Equatable {
    case globe
    case map
}

enum SheetViewMode: Equatable {
    case bottomSheet([SouvenirListItem])
    case carousel([SouvenirListItem])
    case hide
}

enum BottomSheetLevel: Equatable {
    case min
    case mid
    case max
}

// MARK: - Event

enum GlobeEvent {
    case moveCamera(
        coordinate: CLLocationCoordinate2D,
        zoom: CGFloat?,
        animated: Bool,
        extraLift: CGFloat = 0
    )
    case locationPermissionDenied
    case locationError(String)
    case moveCarouselCenter(SouvenirListItem)
    case moveBottomSheetHeight(BottomSheetLevel)
}
