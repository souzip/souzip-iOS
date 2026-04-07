import CoreLocation
import Domain

/// 위치 검색 결과 화면에서 검색 화면으로 돌아갈 때 전달할 상태 (pop 애니메이션 없이 동기화)
enum LocationSearchResumeFromResult {
    /// 검색바 탭: 현재 검색어 유지 후 재검색
    case refineQuery(String)
    /// X 탭: 검색어 비우고 초기 검색 화면
    case clearAndRestart
}

enum SouvenirRoute {
    case create
    case edit(
        detail: SouvenirDetail,
        onResult: (SouvenirDetail) -> Void
    )
    case detail(id: Int)
    case search(SearchCountryContext)
    case locationSearchResult(
        items: [SearchResultItem],
        searchText: String,
        centerCoordinate: CLLocationCoordinate2D,
        onConfirm: (SearchResultItem) -> Void
    )
    case popToSearchFromLocationResult(LocationSearchResumeFromResult)
    case locationPicker(
        initialCoordinate: CLLocationCoordinate2D,
        onComplete: (CLLocationCoordinate2D, String) -> Void
    )
    case categoryPicker(
        initailCategory: SouvenirCategory?,
        onComplete: (SouvenirCategory) -> Void
    )

    case pop
    case dismiss
    case poptoForm

    case finish
}
