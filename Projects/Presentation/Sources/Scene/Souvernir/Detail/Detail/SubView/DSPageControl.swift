import DesignSystem
import SnapKit
import UIKit

public final class DSPageControl: UIView {
    // MARK: - Properties

    private var indicators: [UIView] = []

    public var numberOfPages: Int = 0 {
        didSet {
            setupIndicators()
        }
    }

    public var currentPage: Int = 0 {
        didSet {
            updateIndicators()
        }
    }

    public var currentIndicatorColor: UIColor = .dsGrey900 {
        didSet {
            updateIndicators()
        }
    }

    public var indicatorColor: UIColor = .dsGrey80 {
        didSet {
            updateIndicators()
        }
    }

    private let currentIndicatorWidth: CGFloat = 18
    private let indicatorWidth: CGFloat = 8
    private let indicatorHeight: CGFloat = 8
    private let indicatorSpacing: CGFloat = 8

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        return stack
    }()

    // MARK: - Initialization

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupView() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(indicatorHeight)
        }
    }

    private func setupIndicators() {
        // 기존 indicators 제거
        indicators.forEach { $0.removeFromSuperview() }
        indicators.removeAll()

        // 새로운 indicators 생성
        for _ in 0 ..< numberOfPages {
            let indicator = UIView()
            indicator.backgroundColor = indicatorColor
            indicator.layer.cornerRadius = indicatorHeight / 2
            stackView.addArrangedSubview(indicator)
            indicators.append(indicator)
        }

        stackView.spacing = indicatorSpacing
        updateIndicators()
    }

    private func updateIndicators() {
        guard !indicators.isEmpty else { return }

        UIView.animate(withDuration: 0.3) {
            for (index, indicator) in self.indicators.enumerated() {
                let isCurrent = index == self.currentPage

                indicator.snp.remakeConstraints { make in
                    make.width.equalTo(isCurrent ? self.currentIndicatorWidth : self.indicatorWidth)
                    make.height.equalTo(self.indicatorHeight)
                }

                indicator.backgroundColor = isCurrent ? self.currentIndicatorColor : self.indicatorColor
                indicator.layer.cornerRadius = self.indicatorHeight / 2
            }

            self.layoutIfNeeded()
        }
    }
}
