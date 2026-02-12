import DesignSystem
import Domain
import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class LoginBottomSheetView: BaseView<LoginBottomSheetAction> {
    // MARK: - Constants

    private enum Metric {
        static let horizontalInset: CGFloat = 20
    }

    private enum Strings {
        static let title = "로그인하고\n나만의 컬렉션을 만들어보세요!"
    }

    // MARK: - UI

    private let titleLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.text = Strings.title
        label.textColor = .dsGreyWhite
        label.numberOfLines = 2
        label.setTypography(.body1SB)
        return label
    }()

    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(.dsIconCancel.withTintColor(.dsGrey500), for: .normal)
        return button
    }()

    private let loginButtonStackView = LoginButtonStackView()

    // MARK: - Override

    override func setHierarchy() {
        [
            titleLabel,
            closeButton,
            loginButtonStackView,
        ].forEach { addSubview($0) }
    }

    override func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.equalToSuperview().inset(Metric.horizontalInset)
        }

        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(Metric.horizontalInset)
            make.size.equalTo(24)
        }

        loginButtonStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(Metric.horizontalInset)
            make.height.equalTo(loginButtonStackView.totalHeight)
            make.bottom.equalToSuperview().inset(20)
        }
    }

    override func setBindings() {
        bind(closeButton.rx.tap).to(.close)
        bind(loginButtonStackView.action).map { .tapLogin($0) }
    }
}
