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

    var urlString: String? {
        switch self {
        case .age14: nil
        case .service:
            "https://noiseless-hornet-d9e.notion.site/2c7d4699d3f5801885cfc72d69e16a34"
        case .privacy:
            "https://noiseless-hornet-d9e.notion.site/2c7d4699d3f5802499befa952e59529e"
        case .location:
            "https://noiseless-hornet-d9e.notion.site/2c7d4699d3f580db899bcb4bd78c8012"
        case .marketing:
            "https://noiseless-hornet-d9e.notion.site/2c7d4699d3f580cdbe77dce440e8e85f"
        }
    }
}
