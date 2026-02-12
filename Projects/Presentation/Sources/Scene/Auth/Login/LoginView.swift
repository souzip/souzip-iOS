import DesignSystem
import Domain
import SnapKit
import UIKit

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

    private let loginButtonStackView = LoginButtonStackView()

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
    }

    override func setHierarchy() {
        [
            bgImageView,
            gradientView,
            logoImageView,
            welcomeLabel,
            loginButtonStackView,
            guestButton,
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
            make.bottom.equalTo(loginButtonStackView.snp.top).offset(-Metric.welcomeBottomSpacing)
            make.centerX.equalToSuperview()
        }

        loginButtonStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Metric.horizontalInset)
            make.bottom.equalTo(guestButton.snp.top).offset(-Metric.buttonStackBottomSpacing)
            make.height.equalTo(loginButtonStackView.totalHeight)
        }

        guestButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(Metric.guestButtonBottomInset)
            make.height.equalTo(Metric.guestButtonHeight)
            make.centerX.equalToSuperview()
        }
    }

    override func setBindings() {
        bind(loginButtonStackView.action).map { .tapLogin($0) }
        bind(guestButton.rx.tap).to(.tapGuest)
    }

    // MARK: - Render

    func render(_ provider: AuthProvider?) {
        guard let provider,
              let button = loginButtonStackView.button(for: provider)
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
}
