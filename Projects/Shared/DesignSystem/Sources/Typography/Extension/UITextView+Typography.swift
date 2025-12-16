import UIKit

public extension UITextView {
    func setTypography(_ typography: Typography, text: String) {
        font = typography.font
        attributedText = NSAttributedString(
            string: text,
            attributes: typography.toAttributes()
        )
    }
}
