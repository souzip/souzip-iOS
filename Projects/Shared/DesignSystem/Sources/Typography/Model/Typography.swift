import UIKit

public struct Typography {
    public let font: UIFont
    public let lineHeightMultiple: CGFloat?
    public let letterSpacing: CGFloat

    public init(
        font: UIFont,
        lineHeightMultiple: CGFloat? = nil,
        letterSpacing: CGFloat = 0
    ) {
        self.font = font
        self.lineHeightMultiple = lineHeightMultiple
        self.letterSpacing = letterSpacing
    }

    public var actualLineHeight: CGFloat? {
        lineHeightMultiple.map { font.lineHeight * $0 }
    }

    public func toAttributes() -> [NSAttributedString.Key: Any] {
        var attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .kern: letterSpacing,
        ]

        if let lineHeight = actualLineHeight {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.minimumLineHeight = lineHeight
            paragraphStyle.maximumLineHeight = lineHeight

            let baselineOffset = (lineHeight - font.lineHeight) / 2
            attributes[.baselineOffset] = baselineOffset
            attributes[.paragraphStyle] = paragraphStyle
        }

        return attributes
    }
}
