import DesignSystem
import RxCocoa
import SnapKit
import UIKit

final class GuestLoginView: BaseView<Void> {
    // MARK: - UI

    private let containerView = UIView()

    private let titleLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.text = "로그인이 필요해요"
        label.textColor = .dsGreyWhite
        label.textAlignment = .center
        label.setTypography(.body1SB)
        return label
    }()

    private let descriptionLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.text = "로그인하고 내 취향에 딱 맞는\n기념품들을 모아보세요!"
        label.textColor = .dsGrey80
        label.textAlignment = .center
        label.numberOfLines = 2
        label.setTypography(.body2R)
        return label
    }()

    private let loginButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .dsGrey800
        config.baseForegroundColor = .dsGreyWhite
        config.background.cornerRadius = 4
        config.setTypography(.body2R, title: "로그인하기")
        return UIButton(configuration: config)
    }()

    // MARK: - Override

    override func setAttributes() {
        backgroundColor = .clear
    }

    override func setHierarchy() {
        addSubview(containerView)

        [
            titleLabel,
            descriptionLabel,
            loginButton,
        ].forEach(containerView.addSubview)
    }

    override func setConstraints() {
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(27)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
        }

        loginButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(12)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(117)
            make.height.equalTo(42)
        }
    }

    override func setBindings() {
        bind(loginButton.rx.tap).to(())
    }
}
