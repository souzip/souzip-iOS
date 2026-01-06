import DesignSystem
import SafariServices
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
        var config = UIButton.Configuration.filled()
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

    override public func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        updateContainerHeight()
    }

    // MARK: - Setup

    private func setup() {
        view.backgroundColor = .clear

        view.addSubview(dimmingView)
        view.addSubview(containerView)

        dimmingView.snp.makeConstraints { $0.edges.equalToSuperview() }

        let totalHeight = Metric.sheetHeight + view.safeAreaInsets.bottom

        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(totalHeight)
            containerBottomConstraint = make.bottom
                .equalToSuperview()
                .offset(totalHeight)
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
        }
    }

    private func bind() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapDimming))
        dimmingView.addGestureRecognizer(tap)

        reportButton.addTarget(self, action: #selector(didTapReport), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
    }

    private func updateContainerHeight() {
        let totalHeight = Metric.sheetHeight + view.safeAreaInsets.bottom

        containerView.snp.updateConstraints { make in
            make.height.equalTo(totalHeight)
        }

        containerBottomConstraint?.update(offset: totalHeight)
    }

    // MARK: - Actions

    @objc private func didTapDimming() {
        dismissAnimation { [weak self] in
            self?.dismiss(animated: false)
        }
    }

    @objc private func didTapReport() {
        dismissAnimation { [weak self] in
            let urlString = "https://docs.google.com/forms/d/e/1FAIpQLSeI3EI2-KKDzv5fCpfOuGdrjDjHxKN212SFNym0exyNVoLgHg/viewform"

            guard let url = URL(string: urlString) else { return }

            let vc = SFSafariViewController(url: url)
            vc.modalPresentationStyle = .pageSheet
            self?.present(vc, animated: true)
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
        let totalHeight = Metric.sheetHeight + view.safeAreaInsets.bottom
        containerBottomConstraint?.update(offset: totalHeight + 12)

        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn]) {
            self.dimmingView.alpha = 0
            self.view.layoutIfNeeded()
        } completion: { _ in
            completion()
        }
    }
}
