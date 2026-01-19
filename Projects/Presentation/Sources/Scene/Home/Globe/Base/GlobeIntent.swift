import CoreLocation
import Domain

// MARK: - Action

enum GlobeAction {
    // User Intent
    case wantToSeeCountry(CountryBadge)
    case wantToSearchLocation
    case wantToGoMyLocation
    case wantToSeeSouvenirPin(SouvenirListItem) // 핀 탭 → 캐러셀 센터만 변경
    case wantToSeeSouvenirDetail(SouvenirListItem) // 그리드/캐러셀 아이템 탭 → 상세
    case wantToUploadSouvenir
    case wantToClose

    // Map Interaction
    case userMovedMap(CLLocationCoordinate2D)
    case userTappedSearchInArea(center: CLLocationCoordinate2D, radius: Double)

    // Sheet Interaction
    case userChangedSheetLevel(SheetLevel)
    case carouselCenterChanged(SouvenirListItem) // 캐러셀 센터 변경 (프로그래밍/사용자 모두)
    case userClosedCarousel

    // Lifecycle
    case viewReady
    case mapReady

    // Navigation
    case didSelectSearchResult(SearchResultItem)
}

// MARK: - State

struct GlobeState {
    var scene: GlobeScene = .globe // 저장용
    var countryBadges: [CountryBadge] = []
    var isFromSearch: Bool = false // 검색에서 왔는지 여부

    // Derived Properties
    var mapMode: MapMode {
        switch scene {
        case .globe:
            .globe
        case .mapWithSheet, .mapWithCarousel:
            .map
        }
    }

    var souvenirs: [SouvenirListItem] {
        switch scene {
        case .globe:
            []
        case let .mapWithSheet(context):
            context.souvenirs
        case let .mapWithCarousel(context):
            context.souvenirs
        }
    }

    var searchQuery: String? {
        switch scene {
        case .globe:
            nil
        case let .mapWithSheet(context):
            context.searchQuery
        case let .mapWithCarousel(context):
            context.searchQuery
        }
    }

    var showSearchButton: Bool {
        switch scene {
        case .globe, .mapWithCarousel:
            false
        case let .mapWithSheet(context):
            context.showSearchButton
        }
    }
}

// MARK: - Scene

enum GlobeScene: Equatable {
    case globe
    case mapWithSheet(MapSheetContext)
    case mapWithCarousel(CarouselContext)
}

struct MapSheetContext: Equatable {
    let souvenirs: [SouvenirListItem]
    let sheetLevel: SheetLevel
    let center: CLLocationCoordinate2D
    let searchQuery: String?
    let showSearchButton: Bool

    static func == (lhs: MapSheetContext, rhs: MapSheetContext) -> Bool {
        lhs.souvenirs.map(\.id) == rhs.souvenirs.map(\.id) &&
            lhs.sheetLevel == rhs.sheetLevel &&
            lhs.center.latitude == rhs.center.latitude &&
            lhs.center.longitude == rhs.center.longitude &&
            lhs.searchQuery == rhs.searchQuery &&
            lhs.showSearchButton == rhs.showSearchButton
    }
}

struct CarouselContext: Equatable {
    let souvenirs: [SouvenirListItem]
    let selectedItem: SouvenirListItem
    let searchQuery: String? // 검색 쿼리 유지

    static func == (lhs: CarouselContext, rhs: CarouselContext) -> Bool {
        lhs.souvenirs.map(\.id) == rhs.souvenirs.map(\.id) &&
            lhs.selectedItem.id == rhs.selectedItem.id &&
            lhs.searchQuery == rhs.searchQuery
    }
}

// MARK: - Supporting Types

enum MapMode {
    case globe
    case map
}

enum SheetLevel {
    case min
    case mid
    case max
}

// MARK: - Event

enum GlobeEvent {
    case renderScene(GlobeScene) // Scene 렌더링 (카메라 이동 포함)
    case transitionToSheetWithoutCamera(MapSheetContext) // Sheet 전환 (카메라 이동 없음)
    case scrollCarouselToItem(SouvenirListItem) // 캐러셀 스크롤 (프로그래밍 방식)
    case moveCameraAndSelectPin(SouvenirListItem) // 카메라 이동 & 핀 선택
    case updateSouvenirsAndPinsOnly([SouvenirListItem]) // 기념품과 핀만 업데이트
    case showSearchButton(Bool) // 검색 버튼만 표시/숨김
    case showLocationPermissionAlert
    case showError(String)
}
