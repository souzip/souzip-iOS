import DesignSystem
import Foundation

enum TermsConstants {
    // MARK: - Strings

    enum Strings {
        static let navigationTitle = "이용약관"
        static let title = "이용약관 동의가 필요해요"
        static let allAgree = "모두 동의합니다"
        static let agreeButton = "동의하기"
        static let marketingConfirmMessage = "마케팅 수신에 미동의 시,\n이벤트/혜택 알림을 받을 수 없어요."
        static let marketingConfirmTitle = "동의"
        static let marketingCancelTitle = "미동의"
    }

    // MARK: - Metrics

    // View

    static let horizontalInset: CGFloat = 20

    // Navigation Bar
    static let naviBarTopOffset: CGFloat = 0

    // Title Label
    static let titleTopOffset: CGFloat = 12
    static let titleHorizontalInset: CGFloat = 20
    static let titleHeight: CGFloat = 36

    // Collection View
    static let collectionViewTopOffset: CGFloat = 46
    static let collectionViewBottomOffset: CGFloat = -12

    // Agree Button
    static let agreeButtonHorizontalInset: CGFloat = 20
    static let agreeButtonBottomInset: CGFloat = 20
    static let agreeButtonHeight: CGFloat = 50

    // Collection Layout
    static let itemHeight: CGFloat = 48
    static let termsTopInset: CGFloat = 8

    // MARK: - Cell

    // Checkbox
    static let checkboxSize: CGFloat = 24
    static let checkboxLeadingOffset: CGFloat = 0

    // Title
    static let titleLeadingOffset: CGFloat = 8

    // Detail Button
    static let detailButtonSize: CGFloat = 24
    static let detailButtonTrailingOffset: CGFloat = 0
}
