import DesignSystem
import SnapKit
import UIKit

final class MapSearchBarView: UIView {
    // MARK: - Types

    enum Mode {
        case globe // Globe Scene
        case mapEmpty // Map Exploring (검색어 없음)
        case mapWithQuery(String) // Map with Sheet (검색어 있음)
    }

    // MARK: - UI

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear.withAlphaComponent(0.14)
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.dsGrey500.cgColor
        view.layer.borderWidth = 1
        view.clipsToBounds = true
        return view
    }()

    private let blurView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialLight))
        view.isUserInteractionEnabled = false
        view.alpha = 0.7
        return view
    }()

    private let titleLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.textColor = .dsGreyWhite
        label.setTypography(.body1R)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()

    private let closeButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = .dsIconCancel
        let button = UIButton(configuration: config)
        button.contentHorizontalAlignment = .trailing
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        return button
    }()

    private let searchIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .dsIconSearch
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        return imageView
    }()

    // MARK: - Callbacks

    var onCloseTapped: (() -> Void)?
    var onSearchTapped: (() -> Void)?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Public

    func render(mode: Mode) {
        switch mode {
        case .globe:
            renderGlobeMode()

        case .mapEmpty:
            renderMapEmptyMode()

        case let .mapWithQuery(query):
            renderMapWithQueryMode(query: query)
        }
    }

    // MARK: - Private Rendering

    private func renderGlobeMode() {
        titleLabel.text = "✈️  어디로 떠나시나요?"
        closeButton.isHidden = true
        searchIconImageView.isHidden = false

        updateConstraints(showClose: false, showSearch: true)
    }

    private func renderMapEmptyMode() {
        titleLabel.text = "✈️  어디로 떠나시나요?"
        closeButton.isHidden = false
        searchIconImageView.isHidden = true

        updateConstraints(showClose: true, showSearch: false)
    }

    private func renderMapWithQueryMode(query: String) {
        titleLabel.text = query
        closeButton.isHidden = false
        searchIconImageView.isHidden = true

        updateConstraints(showClose: true, showSearch: false)
    }

    // MARK: - Private Helpers

    private func updateConstraints(showClose: Bool, showSearch: Bool) {
        titleLabel.snp.remakeConstraints {
            $0.leading.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()

            if showClose {
                $0.trailing.lessThanOrEqualTo(closeButton.snp.leading).offset(-8)
            } else if showSearch {
                $0.trailing.lessThanOrEqualTo(searchIconImageView.snp.leading).offset(-8)
            } else {
                $0.trailing.lessThanOrEqualToSuperview().inset(12)
            }
        }
    }
}

// MARK: - UI Configuration

private extension MapSearchBarView {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
        setActions()
    }

    func setAttributes() {
        backgroundColor = .clear

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSearchTap))
        addGestureRecognizer(tapGesture)
    }

    func setHierarchy() {
        addSubview(containerView)
        containerView.addSubview(blurView)

        for item in [titleLabel, closeButton, searchIconImageView] {
            containerView.addSubview(item)
        }
    }

    func setConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        blurView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
        }

        closeButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.verticalEdges.equalToSuperview()
            $0.width.equalTo(closeButton.snp.height)
        }

        searchIconImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
    }

    func setActions() {
        closeButton.addTarget(self, action: #selector(handleCloseTap), for: .touchUpInside)
    }

    @objc private func handleCloseTap() {
        onCloseTapped?()
    }

    @objc private func handleSearchTap() {
        onSearchTapped?()
    }
}
