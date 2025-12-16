public enum PretendardWeight {
    case black
    case bold
    case extraBold
    case extraLight
    case light
    case medium
    case regular
    case semiBold
    case thin

    var postScriptName: String {
        switch self {
        case .black: "Pretendard-Black"
        case .bold: "Pretendard-Bold"
        case .extraBold: "Pretendard-ExtraBold"
        case .extraLight: "Pretendard-ExtraLight"
        case .light: "Pretendard-Light"
        case .medium: "Pretendard-Medium"
        case .regular: "Pretendard-Regular"
        case .semiBold: "Pretendard-SemiBold"
        case .thin: "Pretendard-Thin"
        }
    }
}
