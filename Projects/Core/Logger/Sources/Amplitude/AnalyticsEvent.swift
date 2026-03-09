import Foundation

public enum AnalyticsEvent {
    case app(App)
    case upload(Upload)

    // MARK: - App

    public enum App {
        case tapSouvenirDetail(id: String)
        case tapBanner

        var eventType: String {
            switch self {
            case .tapSouvenirDetail: "click_SOUVENIR DETAIL"
            case .tapBanner: "click_AD_BANNER"
            }
        }

        var properties: [String: Any]? {
            switch self {
            case let .tapSouvenirDetail(id): ["souvenir_id": id]
            default: nil
            }
        }
    }

    // MARK: - 기념품 업로드 퍼널

    public enum Upload {
        case start
        case photoAdded
        case titleAdded
        case locationSet
        case priceAdded
        case targetAdded
        case categoryAdded
        case introduceAdded
        case complete

        var eventType: String {
            switch self {
            case .start: "upload_start"
            case .photoAdded: "upload_photo_added"
            case .titleAdded: "upload_title_added"
            case .locationSet: "upload_location_set"
            case .priceAdded: "upload_price_added"
            case .targetAdded: "upload_target_added"
            case .categoryAdded: "upload_category_added"
            case .introduceAdded: "upload_introduce_added"
            case .complete: "upload_complete"
            }
        }

        var properties: [String: Any]? { nil }
    }

    // MARK: - Computed

    public var eventType: String {
        switch self {
        case let .app(e): e.eventType
        case let .upload(e): e.eventType
        }
    }

    public var properties: [String: Any]? {
        switch self {
        case let .app(e): e.properties
        case let .upload(e): e.properties
        }
    }
}
