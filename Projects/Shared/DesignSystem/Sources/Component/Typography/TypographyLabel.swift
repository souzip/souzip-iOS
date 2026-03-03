import UIKit

public final class TypographyLabel: UILabel {
    // MARK: - Properties

    private var typography: Typography?

    // paragraph 사이 추가 간격 (줄 간격 재배치 등에 활용)
    public var paragraphSpacing: CGFloat? {
        didSet { applyTypography() }
    }

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

        let paragraphStyle: NSMutableParagraphStyle
        if let existing = attributes[.paragraphStyle] as? NSMutableParagraphStyle {
            paragraphStyle = existing
        } else {
            paragraphStyle = NSMutableParagraphStyle()
            attributes[.paragraphStyle] = paragraphStyle
        }
        paragraphStyle.alignment = textAlignment
        if let spacing = paragraphSpacing {
            paragraphStyle.paragraphSpacing = spacing
        }

        attributedText = NSAttributedString(
            string: text,
            attributes: attributes
        )
    }
}
