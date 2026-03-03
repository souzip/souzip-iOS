import SnapKit
import UIKit

public final class DSSpeechBubbleView: UIView {
    // MARK: - Constants

    private enum Metric {
        static let tailHeight: CGFloat = 5
        static let tailWidth: CGFloat = 6
        static let cornerRadius: CGFloat = 9.5
        static let horizontalPadding: CGFloat = 8
        static let verticalPadding: CGFloat = 4
    }

    // MARK: - UI

    private let label = UILabel()

    // MARK: - Layer

    private let bubbleLayer = CAShapeLayer()

    // MARK: - Shadow

    public struct Shadow {
        public let color: UIColor
        public let opacity: Float
        public let offset: CGSize
        public let radius: CGFloat

        public init(
            color: UIColor = .black,
            opacity: Float,
            offset: CGSize = .zero,
            radius: CGFloat
        ) {
            self.color = color
            self.opacity = opacity
            self.offset = offset
            self.radius = radius
        }
    }

    // MARK: - Properties

    private let bubbleColor: UIColor
    private let shadow: Shadow?

    // MARK: - Init

    public init(
        text: String,
        foregroundColor: UIColor = .dsGrey900,
        bubbleColor: UIColor = .dsGreyWhite,
        shadow: Shadow? = nil
    ) {
        self.bubbleColor = bubbleColor
        self.shadow = shadow
        super.init(frame: .zero)
        label.text = text
        label.textColor = foregroundColor
        label.font = .pretendard(size: 9, weight: .medium)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Override

    override public var intrinsicContentSize: CGSize {
        let labelSize = label.intrinsicContentSize
        let width = labelSize.width + Metric.horizontalPadding * 2
        let height = labelSize.height + Metric.verticalPadding * 2 + Metric.tailHeight
        return CGSize(width: width, height: height)
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        guard bounds.height > Metric.tailHeight else { return }
        let path = makeBubblePath(in: bounds)
        bubbleLayer.frame = bounds
        bubbleLayer.path = path.cgPath
        if shadow != nil {
            bubbleLayer.shadowPath = path.cgPath
        }
    }

    // MARK: - Public

    public func setText(_ text: String) {
        label.text = text
        invalidateIntrinsicContentSize()
    }
}

// MARK: - UI Configuration

private extension DSSpeechBubbleView {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        backgroundColor = .clear
        clipsToBounds = false

        bubbleLayer.fillColor = bubbleColor.cgColor
        bubbleLayer.masksToBounds = false
        if let shadow {
            bubbleLayer.shadowColor = shadow.color.cgColor
            bubbleLayer.shadowOpacity = shadow.opacity
            bubbleLayer.shadowOffset = shadow.offset
            bubbleLayer.shadowRadius = shadow.radius
        }
    }

    func setHierarchy() {
        layer.insertSublayer(bubbleLayer, at: 0)
        addSubview(label)
    }

    func setConstraints() {
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Metric.verticalPadding)
            make.bottom.equalToSuperview().inset(Metric.tailHeight + Metric.verticalPadding)
            make.horizontalEdges.equalToSuperview().inset(Metric.horizontalPadding)
        }
    }
}

// MARK: - Path

private extension DSSpeechBubbleView {
    /// 말풍선 전체 경로 (바디 + 꼬리 삼각형)
    func makeBubblePath(in rect: CGRect) -> UIBezierPath {
        let bodyHeight = rect.height - Metric.tailHeight
        let midX = rect.midX
        let tailLeft = midX - Metric.tailWidth / 2
        let tailRight = midX + Metric.tailWidth / 2
        let r = min(Metric.cornerRadius, bodyHeight / 2)

        let path = UIBezierPath()

        // 상단 좌측 → 상단 우측 (top edge)
        path.move(to: CGPoint(x: r, y: 0))
        path.addLine(to: CGPoint(x: rect.maxX - r, y: 0))

        // 상단 우측 모서리 (top-right corner)
        path.addArc(
            withCenter: CGPoint(x: rect.maxX - r, y: r),
            radius: r,
            startAngle: -.pi / 2,
            endAngle: 0,
            clockwise: true
        )

        // 우측 edge → 하단 우측 모서리 (right edge + bottom-right corner)
        path.addLine(to: CGPoint(x: rect.maxX, y: bodyHeight - r))
        path.addArc(
            withCenter: CGPoint(x: rect.maxX - r, y: bodyHeight - r),
            radius: r,
            startAngle: 0,
            endAngle: .pi / 2,
            clockwise: true
        )

        // 하단 오른쪽 → 꼬리 끝 → 하단 왼쪽 (tail: 6×5 이등변삼각형)
        path.addLine(to: CGPoint(x: tailRight, y: bodyHeight))
        path.addLine(to: CGPoint(x: midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: tailLeft, y: bodyHeight))

        // 하단 좌측 모서리 (bottom-left corner)
        path.addLine(to: CGPoint(x: r, y: bodyHeight))
        path.addArc(
            withCenter: CGPoint(x: r, y: bodyHeight - r),
            radius: r,
            startAngle: .pi / 2,
            endAngle: .pi,
            clockwise: true
        )

        // 좌측 edge → 상단 좌측 모서리 (left edge + top-left corner)
        path.addLine(to: CGPoint(x: 0, y: r))
        path.addArc(
            withCenter: CGPoint(x: r, y: r),
            radius: r,
            startAngle: .pi,
            endAngle: -.pi / 2,
            clockwise: true
        )

        path.close()
        return path
    }
}
