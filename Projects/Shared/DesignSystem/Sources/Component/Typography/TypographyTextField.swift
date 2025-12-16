import UIKit

public final class TypographyTextField: UITextField {
    // MARK: - Properties

    private var typography: Typography?

    // MARK: - Public Methods

    public func setTypography(_ typography: Typography) {
        self.typography = typography
        font = typography.font

        if typography.letterSpacing != 0 {
            var attributes = defaultTextAttributes
            attributes[.kern] = typography.letterSpacing
            defaultTextAttributes = attributes
        }
    }

    public func setPlaceholderTypography(
        _ typography: Typography,
        text: String,
        color: UIColor = .systemGray
    ) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: typography.font,
            .kern: typography.letterSpacing,
            .foregroundColor: color,
        ]

        attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: attributes
        )
    }
}
