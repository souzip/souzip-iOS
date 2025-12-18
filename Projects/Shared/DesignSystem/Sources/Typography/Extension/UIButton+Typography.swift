import UIKit

public extension UIButton.Configuration {
    mutating func setTypography(
        _ typography: Typography,
        title: String,
        alignment: NSTextAlignment = .center
    ) {
        var attributes = typography.toAttributes()

        if let paragraphStyle = attributes[.paragraphStyle] as? NSMutableParagraphStyle {
            paragraphStyle.alignment = alignment
        } else if typography.actualLineHeight != nil {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = alignment
            attributes[.paragraphStyle] = paragraphStyle
        }

        attributedTitle = AttributedString(
            NSAttributedString(string: title, attributes: attributes)
        )
    }
}
