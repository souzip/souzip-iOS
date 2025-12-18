import SnapKit
import UIKit

public final class DSAlertView: UIView {
    // MARK: - UI

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .dsGrey900
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()

    private let messageLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.setTypography(.body1SB)
        label.textColor = .dsGreyWhite
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    private let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .pretendard(size: 17, weight: .medium)
        button.setTitleColor(.dsMain, for: .normal)
        button.backgroundColor = .dsMain.withAlphaComponent(0.1)
        button.layer.borderColor = UIColor.dsMain.cgColor
        button.layer.cornerRadius = 8
        return button
    }()

    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .pretendard(size: 17, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .dsGrey700
        button.layer.cornerRadius = 8
        return button
    }()

    private let buttonStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.distribution = .fillEqually
        return stack
    }()

    // MARK: - Properties

    private var confirmHandler: (() -> Void)?
    private var cancelHandler: (() -> Void)?

    // MARK: - Init

    public init() {
        super.init(frame: .zero)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupUI() {
        backgroundColor = .black.withAlphaComponent(0.84)

        addSubview(containerView)
        containerView.addSubview(messageLabel)
        containerView.addSubview(buttonStackView)

        containerView.snp.makeConstraints { make in
            make.width.equalTo(336)
            make.height.equalTo(135)
            make.center.equalToSuperview()
        }

        messageLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.horizontalEdges.equalToSuperview().inset(20)
        }

        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(24)
        }

        confirmButton.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
    }

    // MARK: - Render

    public func render(
        message: String,
        confirmTitle: String = "확인",
        cancelTitle: String? = nil,
        confirmHandler: (() -> Void)? = nil,
        cancelHandler: (() -> Void)? = nil
    ) {
        messageLabel.text = message
        confirmButton.setTitle(confirmTitle, for: .normal)

        self.confirmHandler = confirmHandler
        self.cancelHandler = cancelHandler

        buttonStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        if let cancelTitle {
            cancelButton.setTitle(cancelTitle, for: .normal)
            buttonStackView.addArrangedSubview(cancelButton)
        }
        buttonStackView.addArrangedSubview(confirmButton)
    }

    // MARK: - Actions

    @objc private func confirmTapped() {
        dismiss {
            self.confirmHandler?()
        }
    }

    @objc private func cancelTapped() {
        dismiss {
            self.cancelHandler?()
        }
    }

    // MARK: - Show/Dismiss

    public func show(on viewController: UIViewController) {
        guard let window = viewController.view.window else { return }

        frame = window.bounds
        alpha = 0
        containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)

        window.addSubview(self)

        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0,
            options: .curveEaseOut
        ) {
            self.alpha = 1
            self.containerView.transform = .identity
        }
    }

    private func dismiss(completion: (() -> Void)? = nil) {
        UIView.animate(
            withDuration: 0.2,
            animations: {
                self.alpha = 0
                self.containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            },
            completion: { _ in
                self.removeFromSuperview()
                completion?()
            }
        )
    }
}
