import SnapKit
import UIKit

public final class DSBottomSheetView: UIView {
    // MARK: - UI

    private let dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = .dsBackgroundDimmed
        view.alpha = 0
        return view
    }()

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .dsGrey900
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()

    private let contentContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    // MARK: - Properties

    private var contentView: UIView?

    // MARK: - Callbacks

    var onDimmingTap: (() -> Void)?

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
        addSubview(dimmingView)
        addSubview(containerView)
        containerView.addSubview(contentContainerView)

        dimmingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        containerView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        contentContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(21)
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapDimming))
        dimmingView.addGestureRecognizer(tapGesture)
    }

    // MARK: - Public API

    public func setContentView(_ view: UIView) {
        contentView?.removeFromSuperview()
        contentView = view

        contentContainerView.addSubview(view)
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Animation (Internal - ViewController에서만 호출)

    func animateIn(completion: (() -> Void)? = nil) {
        layoutIfNeeded()

        let containerHeight = containerView.frame.height
        containerView.transform = CGAffineTransform(translationX: 0, y: containerHeight)

        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                self.dimmingView.alpha = 1
                self.containerView.transform = .identity
            },
            completion: { _ in
                completion?()
            }
        )
    }

    func animateOut(completion: (() -> Void)? = nil) {
        let containerHeight = containerView.frame.height

        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: .curveEaseIn,
            animations: {
                self.dimmingView.alpha = 0
                self.containerView.transform = CGAffineTransform(translationX: 0, y: containerHeight)
            },
            completion: { _ in
                completion?()
            }
        )
    }

    // MARK: - Actions

    @objc private func didTapDimming() {
        onDimmingTap?()
    }
}
