import UIKit

public extension UITextView {
    func setTypography(_ typography: Typography, textColor: UIColor) {
        let attrs = typography.toAttributes()

        var typing = attrs
        typing[.foregroundColor] = textColor

        typingAttributes = typing
        font = typography.font
        self.textColor = textColor

        if textStorage.length > 0 {
            textStorage.setAttributes(
                typing,
                range: NSRange(location: 0, length: textStorage.length)
            )
        }
    }
}
