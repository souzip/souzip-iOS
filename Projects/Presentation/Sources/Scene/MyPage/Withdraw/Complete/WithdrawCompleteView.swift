import DesignSystem
import SnapKit
import UIKit

final class WithdrawCompleteView: BaseView<WithdrawCompleteAction> {
    // MARK: - Metric

    private enum Metric {
        static let buttonHeight: CGFloat = 50
        static let buttonHorizontalInset: CGFloat = 19
        static let buttonBottomInset: CGFloat = 21
        static let labelSpacing: CGFloat = 8
    }

    // MARK: - UI

    private let naviBar = DSNavigationBar(title: "회원 탈퇴", style: .title)

    private let titleLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.setTypography(.body1SB)
        label.textColor = .dsGreyWhite
        label.textAlignment = .center
        label.text = "탈퇴되었습니다."
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 17, weight: .light)
        label.textColor = .dsGrey80
        label.textAlignment = .center
        label.text = "개인정보는 30일 내에 삭제됩니다"
        return label
    }()

    private let confirmButton: DSButton = {
        let button = DSButton()
        button.setTitle("확인")
        button.setEnabled(true)
        return button
    }()

    // MARK: - Setup

    override func setAttributes() {
        backgroundColor = .dsBackground
    }

    override func setHierarchy() {
        [naviBar, titleLabel, subtitleLabel, confirmButton].forEach(addSubview)
    }

    override func setConstraints() {
        naviBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-Metric.labelSpacing * 2)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(Metric.labelSpacing)
        }

        confirmButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Metric.buttonHorizontalInset)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(Metric.buttonBottomInset)
            make.height.equalTo(Metric.buttonHeight)
        }
    }

    override func setBindings() {
        bind(confirmButton.rx.tap).to(.tapConfirm)
    }
}
