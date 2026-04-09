import Domain
import Foundation

extension TermsType {
    /// 설정 화면 「이용 약관」 섹션에 노출할 항목 순서. 새 약관 추가 시 여기와 아래 `settingMenuTitle`·`urlString`만 맞추면 됨.
    static let settingMenuOrderedCases: [TermsType] = [
        .service,
        .privacy,
        .location,
        .marketing,
    ]

    /// 설정 리스트 행 제목(온보딩 체크 문구 `title`과 구분)
    var settingMenuTitle: String {
        switch self {
        case .age14:
            ""
        case .service:
            "서비스 이용약관"
        case .privacy:
            "개인정보처리방침"
        case .location:
            "위치기반서비스 이용약관"
        case .marketing:
            "마케팅 정보 수신 동의 안내"
        }
    }

    var title: String {
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
            "https://www.souzip.com/terms"
        case .privacy:
            "https://www.souzip.com/privacy"
        case .location:
            "https://www.souzip.com/location-terms"
        case .marketing:
            "https://www.souzip.com/marketing-terms"
        }
    }
}
