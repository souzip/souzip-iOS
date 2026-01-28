import Foundation

public enum AnalyticsEvent {
    case appOpened
    case tapSouvenirDetail(id: String)
    case tapBanner

    // 이벤트 타입 문자열
    public var eventType: String {
        switch self {
        case .appOpened:
            "app_opened"
        case .tapSouvenirDetail:
            "click_SOUVENIR DETAIL"
        case .tapBanner:
            "click_AD_BANNER"
        }
    }

    // 이벤트 프로퍼티
    public var properties: [String: Any]? {
        switch self {
        case let .tapSouvenirDetail(id):
            ["souvenir_id": id]
        default:
            nil
        }
    }
}
