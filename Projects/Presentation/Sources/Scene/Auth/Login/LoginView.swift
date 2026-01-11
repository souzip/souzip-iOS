import DesignSystem
import Domain
import RxCocoa
import SnapKit
import UIKit

final class LoginView: BaseView<LoginAction> {
    // MARK: - UI

    private let bgImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .dsLoginBackground
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    private let gradientView: UIView = {
        let view = UIView()
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.dsBackground.withAlphaComponent(0).cgColor,
            UIColor.dsBackground.withAlphaComponent(1).cgColor,
        ]
        gradientLayer.locations = [0.0, 0.26]
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
        label.text = "지금 내 주변, 기념품 모음집\n수집에 오신 걸 환영합니다!"
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
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        return stackView
    }()

    private let guestButton: UIButton = {
        var config = UIButton.Configuration.plain()

        let font = UIFont.pretendard(size: 13, weight: .regular)
        let color = UIColor.dsGrey80

        config.attributedTitle = AttributedString(
            NSAttributedString(
                string: "둘러보기",
                attributes: [
                    .font: font,
                    .foregroundColor: color,
                    .underlineStyle: NSUnderlineStyle.single.rawValue,
                    .underlineColor: color,
                ]
            )
        )
        return UIButton(configuration: config)
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

        guestButton.isHidden = true
    }

    override func setHierarchy() {
        [
            bgImageView,
            gradientView,
            logoImageView,
            welcomeLabel,
            lbStackView,
            guestButton,
            recentLoginBadgeView,
        ].forEach(addSubview)
    }

    override func setConstraints() {
        bgImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(bgImageView.snp.width).multipliedBy(1.42)
        }

        gradientView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(278)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        logoImageView.snp.makeConstraints { make in
            make.bottom.equalTo(welcomeLabel.snp.top).offset(-8)
            make.width.equalTo(100)
            make.height.equalTo(60)
            make.centerX.equalToSuperview()
        }

        welcomeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(lbStackView.snp.top).offset(-48)
            make.centerX.equalToSuperview()
        }

        lbStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(102)
            make.height.equalTo(182)
        }
    }

    override func setBindings() {
        for (provider, button) in loginButtons {
            bind(button.rx.tap).to(.tapLogin(provider))
        }

        bind(guestButton.rx.tap).to(.tapGuest)
    }

    // MARK: - Render

    func render(_ provider: AuthProvider?) {
        guard let provider,
              let button = loginButtons[provider]
        else {
            recentLoginBadgeView.isHidden = true
            return
        }

        let shadowWidth = 17
        let shadowHeight = 15

        recentLoginBadgeView.isHidden = false
        recentLoginBadgeView.snp.remakeConstraints { make in
            make.top.equalTo(button.snp.top).offset(-9 - (shadowWidth / 2))
            make.trailing.equalTo(button.snp.trailing).offset(-20 + (shadowWidth / 2))
            make.width.equalTo(86 + shadowWidth)
            make.height.equalTo(24 + shadowHeight)
        }
    }

    // MARK: - Private Logic

    private func makeLoginButtons() {
        for provider in AuthProvider.allCases {
            let button = makeLoginButton(provider)

            if provider == .apple {
                button.layer.borderColor = UIColor.dsGrey900.cgColor
                button.layer.borderWidth = 1
            }

            button.layer.cornerRadius = 10
            button.clipsToBounds = true
            loginButtons[provider] = button
            lbStackView.addArrangedSubview(button)
        }
    }

    private func makeLoginButton(_ provider: AuthProvider) -> UIButton {
        let button = UIButton(type: .system)

        var config = UIButton.Configuration.plain()
        config.imagePlacement = .leading
        config.imagePadding = 12

        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 24)
        config.image = provider.image.withConfiguration(symbolConfig)

        config.baseForegroundColor = provider.titleColor
        config.background.backgroundColor = provider.backgroundColor

        config.setTypography(.body2M, title: provider.title)
        button.configuration = config
        return button
    }
}
