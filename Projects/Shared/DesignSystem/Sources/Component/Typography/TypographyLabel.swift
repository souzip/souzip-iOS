import UIKit

public final class TypographyLabel: UILabel {
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

    // MARK: - Private Methods

    private func applyTypography() {
        guard let typography,
              let text else { return }

        var attributes = typography.toAttributes()

        if let paragraphStyle = attributes[.paragraphStyle] as? NSMutableParagraphStyle {
            paragraphStyle.alignment = textAlignment
        } else {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = textAlignment
            attributes[.paragraphStyle] = paragraphStyle
        }

        attributedText = NSAttributedString(
            string: text,
            attributes: attributes
        )
    }
}
