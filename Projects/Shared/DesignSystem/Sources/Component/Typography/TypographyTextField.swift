import UIKit

public final class TypographyTextField: UITextField {
    // MARK: - Properties

    private var typography: Typography?

    // MARK: - Overrides

    override public var text: String? {
        didSet {
            applyTypography()
        }
    }

    // MARK: - Public Methods

    public func setTypography(_ typography: Typography) {
        self.typography = typography
        font = typography.font
        applyTypography()
    }

    public func setPlaceholderTypography(
        _ typography: Typography,
        text: String,
        color: UIColor = .systemGray
    ) {
        var attributes = typography.toAttributes()
        attributes[.foregroundColor] = color

        attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: attributes
        )
    }

    // MARK: - Private Methods

    private func applyTypography() {
        guard let typography,
              let text,
              !text.isEmpty else { return }

        attributedText = NSAttributedString(
            string: text,
            attributes: typography.toAttributes()
        )
    }
}
