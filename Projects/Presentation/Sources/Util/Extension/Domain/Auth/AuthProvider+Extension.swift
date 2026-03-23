import DesignSystem
import Domain
import UIKit

extension AuthProvider {
    static var allCases: [AuthProvider] {
        [.kakao, .google, .apple]
    }

    var image: UIImage {
        switch self {
        case .kakao: .dsLogoKakao
        case .google: .dsLogoGoogle
        case .apple: .dsLogoApple
        }
    }

    var title: String {
        switch self {
        case .kakao: "카카오로 시작하기"
        case .google: "Google로 시작하기"
        case .apple: "Apple로 시작하기"
        }
    }

    var titleColor: UIColor {
        switch self {
        case .kakao: .black
        case .google: .black
        case .apple: .dsGreyWhite
        }
    }

    var backgroundColor: UIColor {
        switch self {
        case .kakao: #colorLiteral(red: 0.9983025193, green: 0.9065476656, blue: 0, alpha: 1)
        case .google: .dsGreyWhite
        case .apple: .dsBackground
        }
    }

    var borderColor: UIColor? {
        switch self {
        case .apple: .dsGrey900
        default: nil
        }
    }
}
