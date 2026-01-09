import SnapKit
import UIKit

public final class DSIconTitleView: UIView {
    // MARK: - Properties

    public struct Layout {
        let iconSize: CGFloat
        let spacing: CGFloat
        let contentInsets: UIEdgeInsets
        let typography: Typography

        public init(
            iconSize: CGFloat,
            spacing: CGFloat,
            contentInsets: UIEdgeInsets,
            typography: Typography
        ) {
            self.iconSize = iconSize
            self.spacing = spacing
            self.contentInsets = contentInsets
            self.typography = typography
        }
    }

    private let layout: Layout

    // MARK: - UI

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()

    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        return imageView
    }()

    private let titleLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.numberOfLines = 1
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()

    // MARK: - Init

    public init(layout: Layout) {
        self.layout = layout
        super.init(frame: .zero)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public

    public func render(title: String, image: UIImage?) {
        titleLabel.text = title
        iconView.image = image
    }

    public func setTitleColor(_ color: UIColor) {
        titleLabel.textColor = color
    }
}

// MARK: - UI Configuration

private extension DSIconTitleView {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        backgroundColor = .clear
        titleLabel.setTypography(layout.typography)
        stackView.spacing = layout.spacing
    }

    func setHierarchy() {
        addSubview(stackView)
        [
            iconView,
            titleLabel,
        ].forEach(stackView.addArrangedSubview)
    }

    func setConstraints() {
        iconView.snp.makeConstraints { make in
            make.size.equalTo(layout.iconSize)
        }

        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(layout.contentInsets.top)
            make.bottom.equalToSuperview().inset(layout.contentInsets.bottom)
            make.leading.equalToSuperview().inset(layout.contentInsets.left)
            make.trailing.equalToSuperview().inset(layout.contentInsets.right)
        }
    }
}
