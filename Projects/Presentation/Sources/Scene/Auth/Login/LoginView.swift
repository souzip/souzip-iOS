import DesignSystem
import Domain
import RxCocoa
import SnapKit
import UIKit
import Utils

final class LoginView: BaseView<LoginAction> {
    // MARK: - Constants

    private typealias Metric = LoginConstants
    private typealias Strings = LoginConstants.Strings

    // MARK: - UI

    private let bgImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .dsLoginBackground
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let gradientView: UIView = {
        let view = UIView()
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.dsBackground.withAlphaComponent(0).cgColor,
            UIColor.dsBackground.withAlphaComponent(1).cgColor,
        ]
        gradientLayer.locations = [Metric.gradientStartLocation, Metric.gradientEndLocation]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.frame = .zero
        view.layer.addSublayer(gradientLayer)
        return view
    }()

    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .dsLogoSouzip
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let welcomeLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.text = Strings.welcomeMessage
        label.numberOfLines = 2
        label.textColor = .dsGreyWhite
        label.textAlignment = .center
        label.setTypography(.body1SB)
        return label
    }()

    private var loginButtons: [AuthProvider: UIButton] = [:]

    private let lbStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Metric.buttonStackSpacing
        stackView.distribution = .fillEqually
        return stackView
    }()

    private let recentLoginBadgeView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .dsLoginRecent
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    // MARK: - Override

    override func layoutSubviews() {
        super.layoutSubviews()
        (gradientView.layer.sublayers?.first as? CAGradientLayer)?.frame = gradientView.bounds
    }

    override func setAttributes() {
        backgroundColor = .dsBackground
        makeLoginButtons()
    }

    override func setHierarchy() {
        [
            bgImageView,
            gradientView,
            logoImageView,
            welcomeLabel,
            lbStackView,
            recentLoginBadgeView,
        ].forEach(addSubview)
    }

    override func setConstraints() {
        bgImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(Metric.horizontalInset)
            make.height.equalTo(bgImageView.snp.width).multipliedBy(Metric.backgroundImageRatio)
        }

        gradientView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Metric.gradientTopInset)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        logoImageView.snp.makeConstraints { make in
            make.bottom.equalTo(welcomeLabel.snp.top).offset(-Metric.logoBottomSpacing)
            make.width.equalTo(Metric.logoImageWidth)
            make.height.equalTo(Metric.logoImageHeight)
            make.centerX.equalToSuperview()
        }

        welcomeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(lbStackView.snp.top).offset(-Metric.welcomeBottomSpacing)
            make.centerX.equalToSuperview()
        }

        lbStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Metric.horizontalInset)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(Metric.buttonStackBottomInset)
            make.height.equalTo(Metric.buttonStackHeight)
        }
    }

    override func setBindings() {
        for (provider, button) in loginButtons {
            bind(button.rx.tap).to(.tapLogin(provider))
        }
    }

    // MARK: - Render

    func render(_ provider: AuthProvider?) {
        guard let provider,
              let button = loginButtons[provider]
        else {
            recentLoginBadgeView.isHidden = true
            return
        }

        recentLoginBadgeView.isHidden = false
        recentLoginBadgeView.snp.remakeConstraints { make in
            make.top.equalTo(button.snp.top).offset(-Metric.badgeTopOffset)
            make.trailing.equalTo(button.snp.trailing).offset(-Metric.badgeTrailingOffset)
            make.width.equalTo(Metric.badgeWidth)
            make.height.equalTo(Metric.badgeHeight)
        }
    }

    // MARK: - Private Logic

    private func makeLoginButtons() {
        for provider in AuthProvider.allCases {
            let button = makeLoginButton(provider)

            switch provider {
            case .apple:
                button.layer.borderColor = UIColor.dsGrey900.cgColor
                button.layer.borderWidth = Metric.buttonBorderWidth
            default:
                button.layer.borderColor = nil
                button.layer.borderWidth = 0
            }

            button.layer.cornerRadius = Metric.buttonCornerRadius
            button.clipsToBounds = true
            loginButtons[provider] = button
            lbStackView.addArrangedSubview(button)
        }
    }

    private func makeLoginButton(_ provider: AuthProvider) -> UIButton {
        let button = UIButton(type: .system)

        var config = UIButton.Configuration.plain()
        config.imagePlacement = .leading
        config.imagePadding = Metric.loginButtonImagePadding

        let symbolConfig = UIImage.SymbolConfiguration(pointSize: Metric.loginButtonImageSize)
        config.image = provider.image.withConfiguration(symbolConfig)

        config.baseForegroundColor = provider.titleColor
        config.background.backgroundColor = provider.backgroundColor

        config.setTypography(.body2M, title: provider.title)
        button.configuration = config
        return button
    }
}
