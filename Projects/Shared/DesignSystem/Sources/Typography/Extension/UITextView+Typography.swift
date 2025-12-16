import UIKit

public extension UITextView {
    func setTypography(_ typography: Typography, text: String) {
        font = typography.font

        var attributes: [NSAttributedString.Key: Any] = [
            .font: typography.font,
            .kern: typography.letterSpacing,
        ]

        if let lineHeight = typography.lineHeight {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.minimumLineHeight = lineHeight
            paragraphStyle.maximumLineHeight = lineHeight

            let baselineOffset = (lineHeight - typography.font.lineHeight) / 2
            attributes[.baselineOffset] = baselineOffset
            attributes[.paragraphStyle] = paragraphStyle
        }

        attributedText = NSAttributedString(string: text, attributes: attributes)
    }
}
