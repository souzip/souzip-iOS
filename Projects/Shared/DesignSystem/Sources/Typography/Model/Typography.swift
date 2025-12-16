import UIKit

public struct Typography {
    public let font: UIFont
    public let lineHeight: CGFloat?
    public let letterSpacing: CGFloat

    public init(
        fontName: String,
        fontSize: CGFloat,
        lineHeight: CGFloat? = nil,
        letterSpacing: CGFloat = 0
    ) {
        font = UIFont(name: fontName, size: fontSize) ?? .systemFont(ofSize: fontSize)
        self.lineHeight = lineHeight
        self.letterSpacing = letterSpacing
    }
}
