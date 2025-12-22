import SnapKit
import UIKit

public final class DSNavigationBar: UIView {
    // MARK: - Types

    public enum Style {
        case back // back
        case close // close
        case backSettings // back + settings
        case backManage // back + edit, delete
    }

    public enum RightButton {
        case settings
        case edit
        case delete

        var image: UIImage? {
            switch self {
            case .settings: .dsIconSettingBold
            case .edit: .dsIconEdit
            case .delete: .dsIconTrash
            }
        }
    }

    enum LeftButton {
        case back
        case close

        var image: UIImage? {
            switch self {
            case .back: .dsIconChevronLeft
            case .close: .dsIconCancel
            }
        }
    }

    // MARK: - Events

    private var onLeftTapHandler: (() -> Void)?
    private var onRightTapHandler: ((RightButton) -> Void)?

    // MARK: - UI

    private let leftButton = UIButton(type: .system)

    private let titleLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.setTypography(.body1SB)
        label.textAlignment = .center
        label.textColor = .dsGreyWhite
        return label
    }()

    private let rightStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 0
        return stackView
    }()

    // MARK: - Properties

    private let style: Style

    // MARK: - Init

    public init(title: String, style: Style) {
        self.style = style
        super.init(frame: .zero)
        configure()
        render(title: title, style: style)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public

    public func onLeftTap(_ handler: @escaping () -> Void) {
        onLeftTapHandler = handler
    }

    public func onRightTap(_ handler: @escaping (RightButton) -> Void) {
        onRightTapHandler = handler
    }

    // MARK: - Render

    private func render(title: String, style: Style) {
        titleLabel.text = title

        switch style {
        case .back:
            renderLeft(.back)

        case .close:
            renderLeft(.close)

        case .backSettings:
            renderLeft(.back)
            renderRight([.settings])

        case .backManage:
            renderLeft(.back)
            renderRight([.edit, .delete])
        }
    }

    private func renderLeft(_ button: LeftButton) {
        leftButton.setImage(button.image, for: .normal)
    }

    private func renderRight(_ buttons: [RightButton]) {
        for button in buttons {
            let btn = UIButton(type: .system)
            btn.setImage(button.image, for: .normal)
            btn.tintColor = .dsGreyWhite

            btn.snp.makeConstraints { $0.size.equalTo(40) }

            btn.addAction(
                UIAction { [weak self] _ in
                    self?.onRightTapHandler?(button)
                },
                for: .touchUpInside
            )

            rightStackView.addArrangedSubview(btn)
        }
    }
}

// MARK: - UI Configuration

private extension DSNavigationBar {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
        setBindings()
    }

    func setAttributes() {
        backgroundColor = .clear
    }

    func setHierarchy() {
        [
            leftButton,
            titleLabel,
            rightStackView,
        ].forEach { addSubview($0) }
    }

    func setConstraints() {
        snp.makeConstraints { make in
            make.height.equalTo(60)
        }

        leftButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.size.equalTo(40)
        }

        rightStackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.greaterThanOrEqualTo(leftButton.snp.trailing).offset(8)
            make.trailing.lessThanOrEqualTo(rightStackView.snp.leading).offset(-8)
        }
    }

    func setBindings() {
        leftButton.addAction(
            UIAction { [weak self] _ in
                self?.onLeftTapHandler?()
            },
            for: .touchUpInside
        )
    }
}
