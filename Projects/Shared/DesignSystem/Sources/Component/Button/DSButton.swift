import UIKit

public final class DSButton: UIButton {
    // MARK: - Init

    public init() {
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public

    public func setTitle(_ title: String) {
        var config = configuration ?? UIButton.Configuration.plain()
        config.setTypography(.body2SB, title: title)
        configuration = config
    }

    public func setEnabled(_ enabled: Bool) {
        isEnabled = enabled
        applyStyle(isEnabled: enabled)
    }

    // MARK: - Private

    private func applyStyle(isEnabled: Bool) {
        var config = configuration ?? .plain()

        if isEnabled {
            config.baseForegroundColor = .dsGreyWhite
            backgroundColor = .dsMain
        } else {
            config.baseForegroundColor = .dsGrey500
            backgroundColor = .dsGrey700
        }

        configuration = config
    }
}
