import DesignSystem
import Domain
import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class LoginButtonStackView: BaseView<AuthProvider> {
    // MARK: - Constants

    private enum Metric {
        static let spacing: CGFloat = 16
        static let cornerRadius: CGFloat = 10
        static let borderWidth: CGFloat = 1
        static let buttonHeight: CGFloat = 50
        static let imagePadding: CGFloat = 12
        static let imageSize: CGFloat = 24
    }

    // MARK: - UI

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Metric.spacing
        stackView.distribution = .fillEqually
        return stackView
    }()

    private var buttons: [AuthProvider: UIButton] = [:]

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Override

    override func setAttributes() {
        makeLoginButtons()
    }

    override func setHierarchy() {
        addSubview(stackView)
    }

    override func setConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func makeLoginButtons() {
        for provider in AuthProvider.allCases {
            let button = makeLoginButton(provider)
            applyButtonStyle(button, provider: provider)
            buttons[provider] = button
            stackView.addArrangedSubview(button)
            bindButtonTap(button, provider: provider)
        }
    }

    private func makeLoginButton(_ provider: AuthProvider) -> UIButton {
        var config = UIButton.Configuration.plain()
        config.imagePlacement = .leading
        config.imagePadding = Metric.imagePadding

        let symbolConfig = UIImage.SymbolConfiguration(pointSize: Metric.imageSize)
        config.image = provider.image.withConfiguration(symbolConfig)

        config.baseForegroundColor = provider.titleColor
        config.background.backgroundColor = provider.backgroundColor

        config.setTypography(.body2M, title: provider.title)
        return UIButton(configuration: config)
    }

    private func applyButtonStyle(_ button: UIButton, provider: AuthProvider) {
        button.layer.borderColor = provider.borderColor?.cgColor
        button.layer.borderWidth = Metric.borderWidth
        button.layer.cornerRadius = Metric.cornerRadius
        button.clipsToBounds = true
    }

    private func bindButtonTap(_ button: UIButton, provider: AuthProvider) {
        bind(button.rx.tap).to(provider)
    }

    // MARK: - Public

    func button(for provider: AuthProvider) -> UIButton? {
        buttons[provider]
    }

    var totalHeight: CGFloat {
        let buttonCount = CGFloat(AuthProvider.allCases.count)
        return Metric.buttonHeight * buttonCount + Metric.spacing * (buttonCount - 1)
    }
}
