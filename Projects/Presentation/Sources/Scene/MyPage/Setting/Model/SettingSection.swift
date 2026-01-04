import Foundation

enum SettingSection: Int, CaseIterable {
    case terms
    case general
    case support
    case etc

    var title: String {
        switch self {
        case .terms: "이용 약관"
        case .general: "기본 설정"
        case .support: "고객 지원"
        case .etc: "기타"
        }
    }
}

extension SettingSection {
    var rows: [SettingRow] {
        switch self {

        case .general:
            [
                .spacer(12),
                .title("기본 설정"),
                .item(.init(
                    type: .appVersion,
                    title: "버전 정보",
                    trailingText: "v 1.0.0",
                    showsChevron: false
                )),
                .spacer(12),
            ]

        case .terms:
            [
                .spacer(12),
                .title("이용 약관"),
                .item(.init(
                    type: .termsOfService,
                    title: "서비스 이용약관",
                    trailingText: nil,
                    showsChevron: true
                )),
                .item(.init(
                    type: .privacyPolicy,
                    title: "개인정보처리방침",
                    trailingText: nil,
                    showsChevron: true
                )),
                .item(.init(
                    type: .locationTerms,
                    title: "위치기반서비스 이용약관",
                    trailingText: nil,
                    showsChevron: true
                )),
                .item(.init(
                    type: .marketingConsentInfo,
                    title: "마케팅 정보 수신 동의 안내",
                    trailingText: nil,
                    showsChevron: true
                )),
                .spacer(12),
            ]

        case .support:
            [
                .spacer(12),
                .title("고객 지원"),
                .item(.init(
                    type: .feedback,
                    title: "피드백 하기",
                    trailingText: nil,
                    showsChevron: true
                )),
                .spacer(12),
            ]

        case .etc:
            [
                .spacer(12),
                .title("기타"),
                .item(.init(
                    type: .logout,
                    title: "로그아웃",
                    trailingText: nil,
                    showsChevron: true
                )),
                .item(.init(
                    type: .withdraw,
                    title: "회원 탈퇴하기",
                    trailingText: nil,
                    showsChevron: true
                )),
                .spacer(12),
            ]
        }
    }
}
