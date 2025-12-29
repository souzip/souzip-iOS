import DesignSystem
import SnapKit
import UIKit

final class MapSearchBarView: UIView {
    // MARK: - Types

    struct Configuration {
        let showBackButton: Bool
        let text: String
        let textColor: UIColor
        let showCloseButton: Bool
        let showSearchIcon: Bool

        static let globe = Configuration(
            showBackButton: false,
            text: "✈️  어디로 떠나시나요?",
            textColor: .dsGreyWhite,
            showCloseButton: false,
            showSearchIcon: true
        )

        static let globeBack = Configuration(
            showBackButton: true,
            text: "✈️  어디로 떠나시나요?",
            textColor: .dsGreyWhite,
            showCloseButton: false,
            showSearchIcon: false
        )

        static func map(locationName: String) -> Configuration {
            Configuration(
                showBackButton: true,
                text: locationName,
                textColor: .dsGrey80,
                showCloseButton: true,
                showSearchIcon: false
            )
        }
    }

    // MARK: - UI

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear.withAlphaComponent(0.14)
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.dsGrey500.cgColor
        view.layer.borderWidth = 1
        view.clipsToBounds = true
        return view
    }()

    private let blurView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialLight))
        view.isUserInteractionEnabled = false
        view.alpha = 0.7
        return view
    }()

    private let backButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = .dsIconArrowLeft
        config.contentInsets = .zero

        let button = UIButton(configuration: config)
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        return button
    }()

    private let titleLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.setTypography(.body1R)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()

    private let closeButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = .dsIconCancel
        config.contentInsets = .zero

        let button = UIButton(configuration: config)
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        return button
    }()

    private let searchIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .dsIconSearch
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        return imageView
    }()

    // MARK: - Callbacks

    var onBackTapped: (() -> Void)?
    var onCloseTapped: (() -> Void)?
    var onSearchTapped: (() -> Void)?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Public

    func render(with config: Configuration) {
        backButton.isHidden = !config.showBackButton
        titleLabel.text = config.text
        titleLabel.textColor = config.textColor
        closeButton.isHidden = !config.showCloseButton
        searchIconImageView.isHidden = !config.showSearchIcon

        updateConstraints(config: config)
    }

    // MARK: - Private

    private func updateConstraints(config: Configuration) {
        titleLabel.snp.remakeConstraints {
            if config.showBackButton {
                $0.leading.equalTo(backButton.snp.trailing).offset(8)
            } else {
                $0.leading.equalToSuperview().inset(12)
            }

            $0.centerY.equalToSuperview()

            if config.showCloseButton {
                $0.trailing.lessThanOrEqualTo(closeButton.snp.leading).offset(-8)
            } else if config.showSearchIcon {
                $0.trailing.lessThanOrEqualTo(searchIconImageView.snp.leading).offset(-8)
            } else {
                $0.trailing.lessThanOrEqualToSuperview().inset(12)
            }
        }
    }
}

// MARK: - UI Configuration

private extension MapSearchBarView {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
        setActions()
    }

    func setAttributes() {
        backgroundColor = .clear

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSearchTap))
        addGestureRecognizer(tapGesture)
    }

    func setHierarchy() {
        addSubview(containerView)
        containerView.addSubview(blurView)

        for item in [backButton, titleLabel, closeButton, searchIconImageView] {
            containerView.addSubview(item)
        }
    }

    func setConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        blurView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }

        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
        }

        closeButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }

        searchIconImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
    }

    func setActions() {
        backButton.addTarget(self, action: #selector(handleBackTap), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(handleCloseTap), for: .touchUpInside)
    }

    @objc private func handleBackTap() {
        onBackTapped?()
    }

    @objc private func handleCloseTap() {
        onCloseTapped?()
    }

    @objc private func handleSearchTap() {
        onSearchTapped?()
    }
}
