import DesignSystem
import SnapKit
import UIKit

public final class ReportActionSheetViewController: UIViewController {
    // MARK: - UI

    private let dimmingView: UIView = {
        let v = UIView()
        v.backgroundColor = .dsBackgroundDimmed
        v.alpha = 0
        return v
    }()

    private let containerView: UIView = {
        let v = UIView()
        v.backgroundColor = .dsGrey900
        v.layer.cornerRadius = 20
        v.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        v.clipsToBounds = true
        return v
    }()

    private let reportButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .dsGreyWhite
        config.setTypography(.body1SB, title: "신고하기")
        return UIButton(configuration: config)
    }()

    private let closeButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "닫기"
        config.baseForegroundColor = .dsGreyWhite
        config.baseBackgroundColor = .dsGrey700
        config.background.cornerRadius = 8
        let b = UIButton(configuration: config)
        b.titleLabel?.font = .pretendard(size: 17, weight: .medium)
        return b
    }()

    // MARK: - Animation

    private enum Metric {
        static let sheetHeight: CGFloat = 135
        static let bottomInset: CGFloat = 0 // safeArea에 붙일 거라 0
    }

    private var containerBottomConstraint: Constraint?

    // MARK: - LifeCycle

    override public func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bind()
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentAnimation()
    }

    // MARK: - Setup

    private func setup() {
        view.backgroundColor = .clear

        view.addSubview(dimmingView)
        view.addSubview(containerView)

        dimmingView.snp.makeConstraints { $0.edges.equalToSuperview() }

        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(Metric.sheetHeight)
            containerBottomConstraint = make.bottom
                .equalToSuperview()
                .offset(Metric.sheetHeight)
                .constraint
        }

        containerView.addSubview(reportButton)
        containerView.addSubview(closeButton)

        reportButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(27)
        }

        closeButton.snp.makeConstraints { make in
            make.top.equalTo(reportButton.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().inset(24 + view.safeAreaInsets.bottom)
        }
    }

    private func bind() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapDimming))
        dimmingView.addGestureRecognizer(tap)

        reportButton.addTarget(self, action: #selector(didTapReport), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc private func didTapDimming() {
        dismissAnimation { [weak self] in
            self?.dismiss(animated: false)
        }
    }

    @objc private func didTapReport() {
        dismissAnimation { [weak self] in
            self?.dismiss(animated: false)
            // 구글폼 (TODO)
        }
    }

    @objc private func didTapClose() {
        dismissAnimation { [weak self] in
            self?.dismiss(animated: false)
        }
    }

    // MARK: - Animations

    private func presentAnimation() {
        containerBottomConstraint?.update(offset: 0)

        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut]) {
            self.dimmingView.alpha = 1
            self.view.layoutIfNeeded()
        }
    }

    private func dismissAnimation(completion: @escaping () -> Void) {
        containerBottomConstraint?.update(offset: Metric.sheetHeight + 12)

        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn]) {
            self.dimmingView.alpha = 0
            self.view.layoutIfNeeded()
        } completion: { _ in
            completion()
        }
    }
}
