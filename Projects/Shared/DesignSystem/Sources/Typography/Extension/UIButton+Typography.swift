import UIKit

public extension UIButton {
    func setTypography(
        _ typography: Typography,
        title: String,
        for state: UIControl.State = .normal
    ) {
        titleLabel?.font = typography.font

        var attributes: [NSAttributedString.Key: Any] = [
            .font: typography.font,
            .kern: typography.letterSpacing,
        ]

        if let lineHeight = typography.lineHeight {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.minimumLineHeight = lineHeight
            paragraphStyle.maximumLineHeight = lineHeight
            paragraphStyle.alignment = .center

            let baselineOffset = (lineHeight - typography.font.lineHeight) / 2
            attributes[.baselineOffset] = baselineOffset
            attributes[.paragraphStyle] = paragraphStyle
        }

        let attributedTitle = NSAttributedString(string: title, attributes: attributes)
        setAttributedTitle(attributedTitle, for: state)
    }
}
