import DesignSystem
import Domain
import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class ProfileView: BaseView<ProfileAction> {
    // MARK: - UI

    private let naviBar = DSNavigationBar(
        title: "프로필 설정",
        style: .back
    )

    private let titleLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.text = "프로필을 설정해주세요"
        label.textColor = .dsGreyWhite
        label.numberOfLines = 0
        label.setTypography(.subhead24SB)
        return label
    }()

    private let profileImageContainer = UIControl()

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .dsProfileDefault
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 63
        return imageView
    }()

    private let addImageButton: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .dsIconPlusCircleFilled
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let nicknameTextField: DSTextField = {
        let textField = DSTextField()
        textField.setPlaceholder("닉네임을 2~11자 이내로 입력해주세요.")
        textField.setReturnKeyType()
        return textField
    }()

    private let nicknameErrorLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.textColor = .dsSecondaryError
        label.isHidden = true
        label.numberOfLines = 1
        label.setTypography(.body4M)
        return label
    }()

    private let completeButton: DSButton = {
        let button = DSButton()
        button.setTitle("완료")
        button.setEnabled(false)
        return button
    }()

    // MARK: - Override

    override func setAttributes() {
        backgroundColor = .dsBackground
        hideKeyboardWhenTappedAround()
    }

    override func setHierarchy() {
        [
            naviBar,
            titleLabel,
            profileImageContainer,
            nicknameTextField,
            nicknameErrorLabel,
            completeButton,
        ].forEach { addSubview($0) }

        [
            profileImageView,
            addImageButton,
        ].forEach { profileImageContainer.addSubview($0) }
    }

    override func setConstraints() {
        naviBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(36)
        }

        profileImageContainer.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(52)
            make.centerX.equalToSuperview()
            make.size.equalTo(126)
        }

        profileImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        addImageButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(-1)
            make.bottom.equalToSuperview().inset(9)
            make.size.equalTo(32)
        }

        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileImageContainer.snp.bottom).offset(60)
            make.horizontalEdges.equalToSuperview().inset(20)
        }

        nicknameErrorLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(31)
            make.trailing.equalToSuperview().inset(20)
        }

        completeButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
    }

    override func setBindings() {
        bind(naviBar.onLeftTap).to(.tapBack)
        bind(profileImageContainer.rx.controlEvent(.touchUpInside))
            .to(.tapProfileImage)
        bind(nicknameTextField.onTextChanged).map(Action.updateNickname)
        bind(completeButton.rx.tap).to(.tapCompleteButton)
    }

    // MARK: - Public

    func render(nickname: String) {
        nicknameTextField.setText(nickname)
    }

    func render(countText: String) {
        nicknameTextField.setCharacterCountText(countText)
    }

    func render(errorMessage: String?) {
        nicknameErrorLabel.text = errorMessage

        let hasError = errorMessage != nil

        nicknameTextField.setTextColor(hasError ? .dsSecondaryError : .dsGreyWhite)
        nicknameErrorLabel.isHidden = !hasError
    }

    func render(type: ProfileImageType) {
        profileImageView.image = type.image
    }

    func render(isEnabled: Bool) {
        completeButton.setEnabled(isEnabled)
    }
}
