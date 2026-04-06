import DesignSystem
import UIKit

final class LocationSearchPinView: UIView {
    // MARK: - Constants

    private enum Metric {
        static let normalWidth: CGFloat = 26
        static let normalHeight: CGFloat = 31

        static let selectedWidth: CGFloat = 38
        static let selectedHeight: CGFloat = 45

        static let maxWidth: CGFloat = 38
        static let maxHeight: CGFloat = 45
    }

    // MARK: - UI Components

    private let contentView = UIView()

    private let pinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
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

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: CGRect(
            x: 0,
            y: 0,
            width: Metric.maxWidth,
            height: Metric.maxHeight
        ))
        setupViews()
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

        pinImageView.layer.shadowColor = UIColor.black.cgColor
        pinImageView.layer.shadowOpacity = 0.15
        pinImageView.layer.shadowOffset = .zero
        pinImageView.layer.shadowRadius = 2

        updateLayout(animated: false)
    }

    private func updateLayout(animated: Bool) {
        let width: CGFloat
        let height: CGFloat
        let pinImage: UIImage?

        switch state {
        case .normal:
            width = Metric.normalWidth
            height = Metric.normalHeight
            pinImage = .dsLocationPin

        case .selected:
            width = Metric.selectedWidth
            height = Metric.selectedHeight
            pinImage = .dsLocationPinSelected
        }

        pinImageView.image = pinImage

        let animations = {
            let yOffset = Metric.maxHeight - height

            self.contentView.frame = CGRect(
                x: (Metric.maxWidth - width) / 2,
                y: yOffset,
                width: width,
                height: height
            )

            self.pinImageView.frame = CGRect(
                x: 0,
                y: 0,
                width: width,
                height: height
            )
            self.pinImageView.layer.shadowPath = UIBezierPath(
                rect: CGRect(x: 0, y: 0, width: width, height: height)
            ).cgPath
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
