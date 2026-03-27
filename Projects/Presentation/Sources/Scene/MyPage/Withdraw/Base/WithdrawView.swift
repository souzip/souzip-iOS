import DesignSystem
import SnapKit
import UIKit

final class WithdrawView: BaseView<WithdrawAction> {
    // MARK: - Metric

    private enum Metric {
        static let characterSize = CGSize(width: 150, height: 180)
        static let contentSpacing: CGFloat = 8
        static let buttonHeight: CGFloat = 50
        static let buttonHorizontalInset: CGFloat = 19
        static let buttonBottomInset: CGFloat = 21
        static let buttonSpacing: CGFloat = 12
    }

    // MARK: - UI

    private let naviBar = DSNavigationBar(title: "회원 탈퇴", style: .back)

    private let characterImageView: UIImageView = {
        let iv = UIImageView(image: .dsCharacterWorried)
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let messageLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.setTypography(.body2R)
        label.textColor = .dsGreyWhite
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "함께한 여행들이 여기서 멈춘다고 생각하니\n너무 아쉬워요.\n정말 떠나시는 건가요?"
        return label
    }()

    private let continueButton: DSButton = {
        let button = DSButton()
        button.setTitle("계속 함께하기")
        button.setEnabled(true)
        return button
    }()

    private let withdrawButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.setTypography(.body2SB, title: "탈퇴하기")
        config.baseForegroundColor = .dsSecondaryError
        let button = UIButton(configuration: config)
        button.backgroundColor = .dsGrey700
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()

    // MARK: - Setup

    override func setAttributes() {
        backgroundColor = .dsBackground
    }

    override func setHierarchy() {
        [
            naviBar,
            characterImageView,
            messageLabel,
            continueButton,
            withdrawButton,
        ].forEach(addSubview)
    }

    override func setConstraints() {
        naviBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }

        characterImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-Metric.contentSpacing * 4)
            make.size.equalTo(Metric.characterSize)
        }

        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(characterImageView.snp.bottom).offset(Metric.contentSpacing)
            make.horizontalEdges.equalToSuperview().inset(Metric.buttonHorizontalInset)
        }

        continueButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Metric.buttonHorizontalInset)
            make.bottom.equalTo(withdrawButton.snp.top).offset(-Metric.buttonSpacing)
            make.height.equalTo(Metric.buttonHeight)
        }

        withdrawButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Metric.buttonHorizontalInset)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(Metric.buttonBottomInset)
            make.height.equalTo(Metric.buttonHeight)
        }
    }

    override func setBindings() {
        bind(naviBar.onLeftTap).to(.tapContinue)
        bind(continueButton.rx.tap).to(.tapContinue)
        bind(withdrawButton.rx.tap).to(.tapWithdraw)
    }
}
