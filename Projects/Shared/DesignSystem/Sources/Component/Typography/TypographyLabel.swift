import UIKit

public final class TypographyLabel: UILabel {
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

    // MARK: - Private Methods

    private func applyTypography() {
        guard let typography,
              let text else { return }

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
