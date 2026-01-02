import SnapKit
import UIKit

public final class DSTextField: UIView {
    // MARK: - UI

    private let textField: TypographyTextField = {
        let textField = TypographyTextField()
        textField.backgroundColor = .clear
        textField.textColor = .dsGreyWhite
        textField.setTypography(.body3M)
        return textField
    }()

    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .dsGreyWhite
        return view
    }()

    private let characterCountLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.textColor = .dsGrey500
        label.setTypography(.body4R)
        label.isHidden = true
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()

    private let contentStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.spacing = 8
        return sv
    }()

    // MARK: - Properties

    private var onTextChangedHandler: ((String) -> Void)?

    // MARK: - Init

    public init() {
        super.init(frame: .zero)
        configure()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public

    public func setText(_ text: String) {
        textField.text = text
    }

    public func setPlaceholder(_ placeholder: String) {
        textField.setPlaceholderTypography(
            .body3M,
            text: placeholder,
            color: .dsGrey500
        )
    }

    public func setTextColor(_ color: UIColor) {
        textField.textColor = color
    }

    public func setCharacterCountText(_ text: String) {
        characterCountLabel.isHidden = text.isEmpty
        characterCountLabel.text = text
    }

    public func onTextChanged(_ handler: @escaping (String) -> Void) {
        onTextChangedHandler = handler
    }

    public func setKeyboardType(_ type: UIKeyboardType) {
        textField.keyboardType = type
    }

    public func setReturnKeyType(_ returnKeyType: UIReturnKeyType = .done) {
        textField.returnKeyType = returnKeyType

        textField.removeTarget(
            self,
            action: #selector(textFieldDidReturn),
            for: .editingDidEndOnExit
        )

        textField.addTarget(
            self,
            action: #selector(textFieldDidReturn),
            for: .editingDidEndOnExit
        )
    }

    // MARK: - Private

    @objc private func textDidChange() {
        onTextChangedHandler?(textField.text ?? "")
    }

    @objc private func textFieldDidReturn() {
        textField.resignFirstResponder()
    }
}

// MARK: - UI Configuration

private extension DSTextField {
    func configure() {
        setHierarchy()
        setConstraints()
        setBindings()
    }

    func setHierarchy() {
        addSubview(contentStackView)
        addSubview(underlineView)

        contentStackView.addArrangedSubview(textField)
        contentStackView.addArrangedSubview(characterCountLabel)
    }

    func setConstraints() {
        snp.makeConstraints { make in
            make.height.equalTo(48)
        }

        contentStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
            make.height.equalTo(21)
        }

        underlineView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(10)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }

        textField.snp.makeConstraints { make in
            make.height.equalTo(21)
        }

        underlineView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
    }

    func setBindings() {
        textField.addTarget(
            self,
            action: #selector(textDidChange),
            for: .editingChanged
        )
    }
}
