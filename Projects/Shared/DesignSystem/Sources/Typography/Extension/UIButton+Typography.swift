import UIKit

public extension UIButton {
    func setTypography(
        _ typography: Typography,
        title: String,
        for state: UIControl.State = .normal
    ) {
        titleLabel?.font = typography.font

        var attributes = typography.toAttributes()

        if let paragraphStyle = attributes[.paragraphStyle] as? NSMutableParagraphStyle {
            paragraphStyle.alignment = .center
        } else if typography.actualLineHeight != nil {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            attributes[.paragraphStyle] = paragraphStyle
        }

        let attributedTitle = NSAttributedString(string: title, attributes: attributes)
        setAttributedTitle(attributedTitle, for: state)
    }
}
