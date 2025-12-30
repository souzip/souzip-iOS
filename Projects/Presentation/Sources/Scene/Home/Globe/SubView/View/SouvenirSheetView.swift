import Domain
import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class SouvenirSheetView: UIView {
    // MARK: - Types

    typealias Level = BottomSheetLevel

    // MARK: - UI

    private let containerView = UIView()
    private let grabberView = UIView()

    private let souvenirGridView = SouvenirGridView()

    // MARK: - Height Policy

    private let minHeight: CGFloat = 35
    private var midHeight: CGFloat = 0
    private var maxHeight: CGFloat = 0
    private var currentHeight: CGFloat = 0

    private var heightConstraint: Constraint?
    private var didInstallHeightConstraint = false

    private var pendingLevel: Level?

    // MARK: - Action

    let heightRelay = PublishRelay<CGFloat>()

    // MARK: - Pan

    private var panStartHeight: CGFloat = 0

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard let superview else { return }

        if !didInstallHeightConstraint {
            snp.makeConstraints { make in
                heightConstraint = make.height.equalTo(0).constraint
            }
            didInstallHeightConstraint = true
        }

        superview.layoutIfNeeded()
        recalculateHeights(in: superview)

        if let pendingLevel {
            self.pendingLevel = nil
            setLevel(pendingLevel, animated: false)
        } else if currentHeight == 0 {
            setHeight(midHeight, animated: false)
        } else {
            setHeight(currentHeight, animated: false)
        }

        heightRelay.accept(currentHeight)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let superview else { return }
        recalculateHeights(in: superview)
    }

    // MARK: - Public

    func setLevel(_ level: Level, animated: Bool = true) {
        // 아직 mid/max 계산 전이면 저장했다가 didMoveToSuperview에서 적용
        guard superview != nil, midHeight > 0, maxHeight > 0 else {
            pendingLevel = level
            return
        }

        let target: CGFloat = switch level {
        case .min: minHeight
        case .mid: midHeight
        case .max: maxHeight
        }

        setHeight(target, animated: animated)
    }

    var currentLevel: Level {
        let candidates: [(Level, CGFloat)] = [
            (.min, minHeight),
            (.mid, midHeight),
            (.max, maxHeight),
        ]
        return candidates.min { abs($0.1 - currentHeight) < abs($1.1 - currentHeight) }?.0 ?? .mid
    }

    func renderGrid(_ items: [SouvenirListItem]) {
        souvenirGridView.render(items: items)
    }

    // MARK: - Setup

    private func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
        setGestures()
    }

    private func setAttributes() {
        backgroundColor = .clear

        containerView.backgroundColor = .secondarySystemBackground
        containerView.layer.cornerRadius = 20
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        containerView.layer.masksToBounds = true

        grabberView.backgroundColor = .systemGray3
        grabberView.layer.cornerRadius = 2
    }

    private func setHierarchy() {
        addSubview(containerView)
        [
            grabberView,
            souvenirGridView,
        ].forEach(containerView.addSubview)
    }

    private func setConstraints() {
        containerView.snp.makeConstraints { $0.edges.equalToSuperview() }

        grabberView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(9)
            make.centerX.equalToSuperview()
            make.width.equalTo(36.5)
            make.height.equalTo(4)
        }

        souvenirGridView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(30)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    private func setGestures() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        addGestureRecognizer(pan)
    }

    // MARK: - Heights

    private func recalculateHeights(in parentView: UIView) {
        let fullHeight = parentView.bounds.height
        let safeAreaHeight = parentView.safeAreaLayoutGuide.layoutFrame.height

        let newMid = max(minHeight, fullHeight * 0.5)
        let newMax = max(minHeight, safeAreaHeight)

        if abs(newMax - maxHeight) < 0.5,
           abs(newMid - midHeight) < 0.5 {
            return
        }

        maxHeight = newMax
        midHeight = newMid

        let nextHeight = clamp(currentHeight == 0 ? midHeight : currentHeight, minHeight, maxHeight)
        let didChange = abs(nextHeight - currentHeight) > 0.5
        currentHeight = nextHeight
        heightConstraint?.update(offset: currentHeight)

        if didChange {
            heightRelay.accept(currentHeight)
        }
        superview?.layoutIfNeeded()
    }

    private func setHeight(_ height: CGFloat, animated: Bool) {
        let clamped = clamp(height, minHeight, maxHeight)
        currentHeight = clamped
        heightConstraint?.update(offset: clamped)

        heightRelay.accept(clamped)

        guard let superview else { return }
        if animated {
            UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseOut]) {
                superview.layoutIfNeeded()
            }
        } else {
            superview.layoutIfNeeded()
        }
    }

    private func snapToNearest() {
        let candidates = [minHeight, midHeight, maxHeight]
        let nearest = candidates.min { abs($0 - currentHeight) < abs($1 - currentHeight) } ?? midHeight
        setHeight(nearest, animated: true)
    }

    // MARK: - Pan

    @objc private func handlePan(_ gr: UIPanGestureRecognizer) {
        guard let superview else { return }
        let translation = gr.translation(in: superview)

        switch gr.state {
        case .began:
            panStartHeight = currentHeight

        case .changed:
            let proposed = panStartHeight - translation.y
            setHeight(proposed, animated: false)

        case .ended, .cancelled:
            snapToNearest()

        default:
            break
        }
    }

    // MARK: - Utils

    private func clamp(_ x: CGFloat, _ a: CGFloat, _ b: CGFloat) -> CGFloat {
        min(max(x, a), b)
    }
}
