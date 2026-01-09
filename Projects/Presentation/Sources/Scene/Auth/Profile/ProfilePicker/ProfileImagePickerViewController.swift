import DesignSystem
import Domain
import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class ProfileImagePickerViewController: UIViewController {
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
        button.setImage(.dsIconCancel, for: .normal)
        button.backgroundColor = .dsGrey900
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
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

    private let disposeBag = DisposeBag()
    private var selectedImage: ProfileImageType?

    var onImageSelected: ((ProfileImageType) -> Void)?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

// MARK: - Image Buttons

private extension ProfileImagePickerViewController {
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
        selectedImage = type
        selectButton.setEnabled(true)

        for (key, button) in imageButtons {
            let image = (key == type) ? key.selectedImage : key.image
            button.setImage(image, for: .normal)
        }
    }
}

// MARK: - UI Configuration

private extension ProfileImagePickerViewController {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
        setBindings()
    }

    func setAttributes() {
        view.backgroundColor = #colorLiteral(red: 0.1137254902, green: 0.1137254902, blue: 0.1137254902, alpha: 1)
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.dsGrey700.cgColor

        makeImageButtons()
        selectImage(type: .red)
    }

    func setHierarchy() {
        [
            titleLabel,
            closeButton,
            imageStackView,
            selectButton,
        ].forEach { view.addSubview($0) }
    }

    func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(32)
            make.leading.equalToSuperview().inset(20)
        }

        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(20)
            make.size.equalTo(32)
        }

        imageStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(28)
            make.horizontalEdges.equalToSuperview().inset(20)
        }

        selectButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
    }

    func setBindings() {
        closeButton.rx.tap
            .bind { [weak self] in
                self?.dismiss(animated: true)
            }
            .disposed(by: disposeBag)

        selectButton.rx.tap
            .bind { [weak self] in
                guard let self,
                      let selectedImage
                else { return }

                onImageSelected?(selectedImage)
                dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
}
