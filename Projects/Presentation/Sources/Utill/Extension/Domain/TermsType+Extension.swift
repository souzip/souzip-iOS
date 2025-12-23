import Domain
import Foundation

extension TermsType {
    var baseTitle: String {
        switch self {
        case .age14:
            "만 14세 이상입니다"
        case .service:
            "서비스 이용약관에 동의합니다"
        case .privacy:
            "개인정보 수집 및 이용에 동의합니다"
        case .location:
            "위치기반 서비스 이용약관에 동의합니다"
        case .marketing:
            "마케팅 수신에 동의합니다"
        }
    }

    var detailURL: URL? {
        switch self {
        case .age14: nil
        case .service:
            URL(string: "https://example.com/terms/service")
        case .privacy:
            URL(string: "https://example.com/terms/privacy")
        case .location:
            URL(string: "https://example.com/terms/location")
        case .marketing:
            URL(string: "https://example.com/terms/marketing")
        }
    }
}
