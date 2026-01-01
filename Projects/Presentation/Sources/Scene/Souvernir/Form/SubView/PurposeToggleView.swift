import DesignSystem
import Domain
import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class PurposeToggleView: UIView {
    // MARK: - Properties

    let purposeChanged = PublishRelay<SouvenirPurpose>()
    private let disposeBag = DisposeBag()

    private var currentPurpose: SouvenirPurpose = .personal

    // MARK: - UI

    private let titleLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.textColor = .dsGreyWhite
        label.setTypography(.body1SB)
        return label
    }()

    private let toggleContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.distribution = .fillEqually
        return stackView
    }()

    private let personalButton: UIButton = {
        let button = UIButton()
        button.setTitle("개인용", for: .normal)
        button.setTitleColor(.dsGreyWhite, for: .normal)
        button.titleLabel?.font = .pretendard(size: 17, weight: .medium)
        button.backgroundColor = .dsMain
        button.layer.cornerRadius = 8
        return button
    }()

    private let giftButton: UIButton = {
        let button = UIButton()
        button.setTitle("선물용", for: .normal)
        button.setTitleColor(.dsGrey500, for: .normal)
        button.titleLabel?.font = .pretendard(size: 17, weight: .medium)
        button.backgroundColor = .dsGrey700
        button.layer.cornerRadius = 8
        return button
    }()

    // MARK: - Init

    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        configure()
        setBindings()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public

    func render(_ purpose: SouvenirPurpose) {
        currentPurpose = purpose
        updateButtonStates()
    }

    // MARK: - Private

    private func configure() {
        setHierarchy()
        setConstraints()
        updateButtonStates()
    }

    private func setHierarchy() {
        addSubview(titleLabel)
        addSubview(toggleContainer)

        for item in [personalButton, giftButton] {
            toggleContainer.addArrangedSubview(item)
        }
    }

    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }

        toggleContainer.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(48)
            make.bottom.equalToSuperview()
        }
    }

    private func setBindings() {
        personalButton.rx.tap
            .bind { [weak self] in
                self?.selectPurpose(.personal)
            }
            .disposed(by: disposeBag)

        giftButton.rx.tap
            .bind { [weak self] in
                self?.selectPurpose(.gift)
            }
            .disposed(by: disposeBag)
    }

    private func selectPurpose(_ purpose: SouvenirPurpose) {
        currentPurpose = purpose
        updateButtonStates()
        purposeChanged.accept(purpose)
    }

    private func updateButtonStates() {
        switch currentPurpose {
        case .personal:
            personalButton.backgroundColor = .dsMain.withAlphaComponent(0.1)
            personalButton.setTitleColor(.dsMain, for: .normal)
            personalButton.layer.borderColor = UIColor.dsMain.cgColor
            personalButton.layer.borderWidth = 1

            giftButton.backgroundColor = .dsGrey700
            giftButton.setTitleColor(.dsGreyWhite, for: .normal)
            giftButton.layer.borderColor = nil
            giftButton.layer.borderWidth = 0

        case .gift:
            giftButton.backgroundColor = .dsMain.withAlphaComponent(0.1)
            giftButton.setTitleColor(.dsMain, for: .normal)
            giftButton.layer.borderColor = UIColor.dsMain.cgColor
            giftButton.layer.borderWidth = 1

            personalButton.backgroundColor = .dsGrey700
            personalButton.setTitleColor(.dsGreyWhite, for: .normal)
            personalButton.layer.borderColor = nil
            personalButton.layer.borderWidth = 0
        }
    }
}
