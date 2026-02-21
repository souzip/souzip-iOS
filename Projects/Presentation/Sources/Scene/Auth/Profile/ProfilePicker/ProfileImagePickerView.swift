import DesignSystem
import Domain
import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class ProfileImagePickerView: BaseView<ProfileImagePickerView.Action> {
    // MARK: - Action

    enum Action {
        case close
        case selectImage(ProfileImageType)
    }

    // MARK: - UI

    private let titleLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.text = "프로필 이미지를\n선택해보세요"
        label.textColor = .dsGreyWhite
        label.numberOfLines = 2
        label.setTypography(.subhead24SB)
        return label
    }()

    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(.dsIconCancel.withTintColor(.dsGrey500), for: .normal)
        button.contentMode = .scaleAspectFit
        return button
    }()

    private lazy var imageStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 18
        return stack
    }()

    private var imageButtons: [ProfileImageType: UIButton] = [:]

    private let selectButton: DSButton = {
        let button = DSButton()
        button.setTitle("선택 완료")
        button.setEnabled(false)
        return button
    }()

    // MARK: - Properties

    private let selectedImageRelay = BehaviorRelay<ProfileImageType?>(value: nil)

    // MARK: - Setup

    override func setAttributes() {
        makeImageButtons()
        selectImage(type: .red)
    }

    override func setHierarchy() {
        [
            titleLabel,
            closeButton,
            imageStackView,
            selectButton,
        ].forEach { addSubview($0) }
    }

    override func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(46)
            make.leading.equalToSuperview().inset(20)
        }

        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(20)
            make.size.equalTo(24)
        }

        imageStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(28)
            make.horizontalEdges.equalToSuperview().inset(20)
        }

        selectButton.snp.makeConstraints { make in
            make.top.equalTo(imageStackView.snp.bottom).offset(64)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().inset(20)
        }
    }

    override func setBindings() {
        bind(closeButton.rx.tap).to(.close)
        bind(selectButton.rx.tap)
            .withLatestFrom(selectedImageRelay)
            .compactMap { $0 }
            .map { .selectImage($0) }
    }
}

// MARK: - Image Buttons

private extension ProfileImagePickerView {
    func makeImageButtons() {
        for type in ProfileImageType.allCases {
            let button = UIButton(type: .system)
            button.setImage(type.image, for: .normal)
            button.imageView?.contentMode = .scaleAspectFit

            button.snp.makeConstraints { make in
                make.height.equalTo(button.snp.width)
            }

            button.rx.tap
                .bind { [weak self] in
                    self?.selectImage(type: type)
                }
                .disposed(by: disposeBag)

            imageButtons[type] = button
            imageStackView.addArrangedSubview(button)
        }
    }

    func selectImage(type: ProfileImageType) {
        selectedImageRelay.accept(type)
        selectButton.setEnabled(true)

        for (key, button) in imageButtons {
            let image = (key == type) ? key.selectedImage : key.image
            button.setImage(image, for: .normal)
        }
    }
}
