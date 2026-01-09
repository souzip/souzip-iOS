import DesignSystem
import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class AddressFieldView: UIView {
    // MARK: - Output

    let tapRelay = PublishRelay<Void>()
    private let disposeBag = DisposeBag()

    // MARK: - UI

    private let titleLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.textColor = .dsGreyWhite
        label.setTypography(.body1SB)
        return label
    }()

    private let textField = DSTextField()

    private let tapOverlayButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        return button
    }()

    private let descriptionLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.textColor = .dsGrey300
        label.setTypography(.body4R)
        label.numberOfLines = 0
        return label
    }()

    private let contentStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .fill
        sv.spacing = 8
        return sv
    }()

    init() {
        super.init(frame: .zero)
        configureFixedTexts()
        configure()
        renderDescription("")
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func configureFixedTexts() {
        titleLabel.text = "위치"
        textField.setPlaceholder("위치를 선택해주세요.")
    }

    // MARK: - Public

    func render(text: String) {
        textField.setText(text)
    }

    func renderDescription(_ text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        let hasText = !trimmed.isEmpty

        descriptionLabel.text = trimmed
        descriptionLabel.isHidden = !hasText
    }

    // MARK: - Private

    private func configure() {
        setHierarchy()
        setConstraints()
        setNonEditable()
        setBindings()
    }

    private func setHierarchy() {
        addSubview(titleLabel)
        addSubview(contentStackView)

        contentStackView.addArrangedSubview(textField)
        contentStackView.addArrangedSubview(descriptionLabel)

        addSubview(tapOverlayButton) // 텍스트필드 영역만 덮기
    }

    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.height.equalTo(27)
        }

        contentStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }

        tapOverlayButton.snp.makeConstraints { make in
            make.edges.equalTo(textField)
        }
    }

    private func setNonEditable() {
        textField.isUserInteractionEnabled = false
    }

    private func setBindings() {
        tapOverlayButton.rx.tap
            .bind(to: tapRelay)
            .disposed(by: disposeBag)
    }
}
