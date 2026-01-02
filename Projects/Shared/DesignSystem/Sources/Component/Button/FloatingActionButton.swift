import SnapKit
import UIKit

public final class DSFAButton: UIButton {

    // MARK: - Initialization

    public init(image: UIImage?) {
        super.init(frame: .zero)
        setupButton(image: image)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupButton(image: UIImage?) {
        var config = UIButton.Configuration.filled()
        config.image = image
        config.baseBackgroundColor = .dsMain
        config.cornerStyle = .capsule

        configuration = config

        // 크기 설정
        snp.makeConstraints { make in
            make.width.height.equalTo(60)
        }

        // 하이라이트 비활성화
        configurationUpdateHandler = { button in
            button.configuration?.background.backgroundColor = .dsMain
        }
    }

    // MARK: - Public Methods

    public func setBackgroundColor(_ color: UIColor) {
        configuration?.baseBackgroundColor = color
    }

    public func setImage(_ image: UIImage?) {
        configuration?.image = image
    }
}
