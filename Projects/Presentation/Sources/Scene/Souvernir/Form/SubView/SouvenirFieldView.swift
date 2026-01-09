import DesignSystem
import RxRelay
import SnapKit
import UIKit

final class SouvenirFieldView: UIView {
    // MARK: - Output

    let textRelay = PublishRelay<String>()

    // MARK: - UI

    private let titleLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.textColor = .dsGreyWhite
        label.setTypography(.body1SB)
        return label
    }()

    private let textField = DSTextField()

    // MARK: - Init

    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        configure()
        setPlaceholder("기념품 이름을 입력해주세요.")
        bind()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public

    func setText(_ text: String) {
        textField.setText(text)
    }

    // MARK: - Private

    private func setPlaceholder(_ placeholder: String) {
        textField.setPlaceholder(placeholder)
    }

    private func configure() {
        setHierarchy()
        setConstraints()
    }

    private func setHierarchy() {
        [titleLabel, textField].forEach(addSubview)
    }

    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.height.equalTo(27)
        }

        textField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    private func bind() {
        textField.onTextChanged { [weak self] text in
            self?.textRelay.accept(text)
        }
    }
}
