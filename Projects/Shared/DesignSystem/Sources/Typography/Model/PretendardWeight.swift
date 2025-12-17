import UIKit

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

public extension UIFont {
    static func pretendard(size: CGFloat, weight: PretendardWeight) -> UIFont {
        let fontName = weight.postScriptName

        guard let font = UIFont(name: fontName, size: size) else {
            return .systemFont(ofSize: size)
        }

        return font
    }
}
