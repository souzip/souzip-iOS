import Domain
import UIKit

final class SouvenirPinView: UIView {
    // MARK: - Constants

    private enum Metric {
        // 기본 상태
        static let normalWidth: CGFloat = 32
        static let normalHeight: CGFloat = 38
        static let normalIconTop: CGFloat = 4
        static let normalIconSize: CGFloat = 24

        // 선택 상태
        static let selectedWidth: CGFloat = 56
        static let selectedHeight: CGFloat = 65
        static let selectedIconTop: CGFloat = 10
        static let selectedIconSize: CGFloat = 36

        // 최대 크기 (선택 상태 기준)
        static let maxWidth: CGFloat = 56
        static let maxHeight: CGFloat = 65
    }

    // MARK: - UI Components

    private let contentView = UIView()

    private let pinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let categoryIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // MARK: - Properties

    enum State {
        case normal
        case selected
    }

    var state: State = .normal {
        didSet {
            updateAppearance()
        }
    }

    private let category: SouvenirCategory

    // MARK: - Initialization

    init(category: SouvenirCategory) {
        self.category = category
        super.init(frame: CGRect(
            x: 0,
            y: 0,
            width: Metric.maxWidth,
            height: Metric.maxHeight
        ))

        setupViews()
        updateIcon()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupViews() {
        backgroundColor = .clear

        addSubview(contentView)
        contentView.addSubview(pinImageView)
        contentView.addSubview(categoryIconImageView)

        updateLayout(animated: false)
    }

    private func updateIcon() {
        categoryIconImageView.image = category.selectedImage
    }

    private func updateLayout(animated: Bool) {
        let width: CGFloat
        let height: CGFloat
        let iconTop: CGFloat
        let iconSize: CGFloat
        let pinImage: UIImage?

        switch state {
        case .normal:
            width = Metric.normalWidth
            height = Metric.normalHeight
            iconTop = Metric.normalIconTop
            iconSize = Metric.normalIconSize
            pinImage = .dsSouvenirPin

        case .selected:
            width = Metric.selectedWidth
            height = Metric.selectedHeight
            iconTop = Metric.selectedIconTop
            iconSize = Metric.selectedIconSize
            pinImage = .dsSouvenirPinSelected
        }

        pinImageView.image = pinImage

        let animations = {
            // ✅ contentView를 하단에 배치 (위로 자라도록)
            let yOffset = Metric.maxHeight - height

            self.contentView.frame = CGRect(
                x: (Metric.maxWidth - width) / 2,
                y: yOffset,
                width: width,
                height: height
            )

            // pinImageView - contentView 전체 영역
            self.pinImageView.frame = CGRect(
                x: 0,
                y: 0,
                width: width,
                height: height
            )

            // categoryIconImageView - 중앙 상단 배치
            let iconX = (width - iconSize) / 2
            self.categoryIconImageView.frame = CGRect(
                x: iconX,
                y: iconTop,
                width: iconSize,
                height: iconSize
            )
        }

        if animated {
            UIView.animate(withDuration: 0.3, animations: animations)
        } else {
            animations()
        }
    }

    private func updateAppearance() {
        updateLayout(animated: true)
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()

        if superview != nil {
            updateLayout(animated: false)
        }
    }
}
