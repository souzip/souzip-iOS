import DesignSystem
import Foundation

enum LoginConstants {
    // MARK: - Strings

    enum Strings {
        static let welcomeMessage = "지금 내 주변, 기념품 모음집\n수집에 오신 걸 환영합니다!"
        static let guestButtonTitle = "둘러보기"
    }

    // MARK: - Metrics

    static let horizontalInset: CGFloat = LayoutConstants.Inset.horizontal

    // 그라데이션
    static let gradientTopInset: CGFloat = 278
    static let gradientStartLocation: NSNumber = 0.0
    static let gradientEndLocation: NSNumber = 0.26

    // 수집 로고
    static let logoImageWidth: CGFloat = 100
    static let logoImageHeight: CGFloat = 60
    static let logoBottomSpacing: CGFloat = LayoutConstants.Spacing.xSmall

    // 환영 라벨
    static let welcomeBottomSpacing: CGFloat = LayoutConstants.Spacing.xxLarge

    // 로그인 버튼 스택뷰
    static let buttonStackSpacing: CGFloat = LayoutConstants.Spacing.standard
    static let buttonStackHeight: CGFloat = 182
    static let buttonStackBottomSpacing: CGFloat = 42
    static let buttonCornerRadius: CGFloat = LayoutConstants.CornerRadius.button
    static let buttonBorderWidth: CGFloat = LayoutConstants.BorderWidth.standard

    static let backgroundImageRatio: CGFloat = 1.42

    // 로그인 버튼
    static let loginButtonImagePadding: CGFloat = 12
    static let loginButtonImageSize: CGFloat = 24

    // 게스트 버튼
    static let guestButtonBottomInset: CGFloat = 24
    static let guestButtonHeight = 16

    // 최근 로그인 뱃지
    static let badgeTopOffset: CGFloat = 9 + (badgeShadowWidth / 2)
    static let badgeTrailingOffset: CGFloat = 20 - (badgeShadowHeight / 2)
    static let badgeWidth: CGFloat = 86 + badgeShadowWidth
    static let badgeHeight: CGFloat = 24 + badgeShadowHeight
    static let badgeShadowWidth: CGFloat = 17
    static let badgeShadowHeight: CGFloat = 15
}
