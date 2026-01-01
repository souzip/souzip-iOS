import CoreLocation
import Domain

enum SouvenirRoute {
    case create
    case edit(
        detail: SouvenirDetail,
        onResult: (SouvenirDetail) -> Void
    )
    case detail
    case search(onResult: (SearchResultItem) -> Void)
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
