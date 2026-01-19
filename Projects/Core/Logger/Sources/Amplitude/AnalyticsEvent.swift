import Foundation

public enum AnalyticsEvent {
    case appOpened
    case clickSouvenirDetail(id: String)

    // 이벤트 타입 문자열
    public var eventType: String {
        switch self {
        case .appOpened:
            "app_opened"
        case .clickSouvenirDetail:
            "click_SOUVENIR DETAIL"
        }
    }

    // 이벤트 프로퍼티
    public var properties: [String: Any]? {
        switch self {
        case .appOpened:
            nil

        case let .clickSouvenirDetail(id):
            ["souvenir_id": id]
        }
    }
}
