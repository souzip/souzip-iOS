import UIKit

public final class TypographyTextField: UITextField {
    // MARK: - Properties

    private var typography: Typography?

    // MARK: - Overrides

    override public var textAlignment: NSTextAlignment {
        didSet {
            applyTypography()
        }
    }

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

        var attributes = typography.toAttributes()

        let paragraphStyle: NSMutableParagraphStyle
        if let existing = attributes[.paragraphStyle] as? NSMutableParagraphStyle {
            paragraphStyle = existing
        } else {
            paragraphStyle = NSMutableParagraphStyle()
            attributes[.paragraphStyle] = paragraphStyle
        }
        paragraphStyle.alignment = textAlignment
        paragraphStyle.lineBreakMode = .byTruncatingTail

        attributedText = NSAttributedString(
            string: text,
            attributes: attributes
        )
    }
}
