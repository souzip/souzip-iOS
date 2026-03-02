import SnapKit
import UIKit

public final class DSTabBarView: UIView {
    // MARK: - Constants

    private let baseHeight: CGFloat = 76

    // MARK: - Event

    public var onSelect: ((Int) -> Void)?

    // MARK: - State

    public var items: [DSTabBarItem] = [] {
        didSet { reloadItems() }
    }

    public var selectedIndex: Int = 1 {
        didSet { updateSelection() }
    }

    // MARK: - UI

    private let topBorderView: UIView = {
        let view = UIView()
        view.backgroundColor = .dsGrey700
        return view
    }()

    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .fill
        view.spacing = 0
        return view
    }()

    private var itemViews: [DSTabBarItemView] = []

    private let uploadBubbleView: DSSpeechBubbleView = {
        let view = DSSpeechBubbleView(
            text: "여행 추억, 지금 남겨두기",
            foregroundColor: .dsGreyWhite,
            bubbleColor: .dsMain
        )
        view.isHidden = true
        return view
    }()

    // MARK: - Constraints

    private var heightConstraint: Constraint?
    private var stackBottomConstraint: Constraint?

    // MARK: - Init

    override public init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle

    override public func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        updateSafeAreaConstraints()
    }

    // MARK: - Public

    public func setSelectedIndex(_ index: Int) {
        selectedIndex = index
    }

    public func setUploadBubbleVisible(_ isVisible: Bool) {
        uploadBubbleView.isHidden = !isVisible
    }
}

// MARK: - Private Logic

private extension DSTabBarView {
    func reloadItems() {
        for arrangedSubview in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(arrangedSubview)
            arrangedSubview.removeFromSuperview()
        }
        itemViews.removeAll()

        for (index, item) in items.enumerated() {
            let view = DSTabBarItemView(item: item)
            view.onTap = { [weak self] in
                self?.onSelect?(index)
            }
            stackView.addArrangedSubview(view)
            itemViews.append(view)
        }

        if selectedIndex >= items.count {
            selectedIndex = max(0, items.count - 1)
        }

        updateBubbleConstraints()
    }

    func updateBubbleConstraints() {
        guard itemViews.count >= 3 else { return }
        uploadBubbleView.snp.remakeConstraints { make in
            make.top.equalTo(itemViews[2].snp.top).offset(-16)
            make.centerX.equalTo(itemViews[2].snp.centerX)
        }
    }

    func updateSelection() {
        for (index, view) in itemViews.enumerated() {
            view.setSelected(index == selectedIndex)
        }
    }

    func updateSafeAreaConstraints() {
        heightConstraint?.update(offset: baseHeight + safeAreaInsets.bottom)
        stackBottomConstraint?.update(offset: safeAreaInsets.bottom)
    }
}

// MARK: - UI Configuration

private extension DSTabBarView {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        backgroundColor = .dsBackground
        updateSafeAreaConstraints()
    }

    func setHierarchy() {
        [
            stackView,
            topBorderView,
            uploadBubbleView,
        ].forEach(addSubview)
    }

    func setConstraints() {
        snp.makeConstraints { make in
            heightConstraint = make.height.equalTo(baseHeight).constraint
        }

        topBorderView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }

        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            stackBottomConstraint = make.bottom.equalToSuperview().constraint
        }
    }
}
