import DesignSystem
import SnapKit
import UIKit

final class DiscoverySectionHeaderView: UICollectionReusableView {
    // MARK: - UI

    private let titleLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.setTypography(.body1SB)
        label.textColor = .dsGreyWhite
        label.numberOfLines = 0
        return label
    }()

    private let subtitleLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.setTypography(.body4R)
        label.textColor = .dsGrey300
        label.numberOfLines = 1
        return label
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public

    func render(section: DiscoverySection) {
        titleLabel.text = section.title
        subtitleLabel.text = section.subTitle
        subtitleLabel.isHidden = section.subTitle.isEmpty
    }
}

// MARK: - UI Configuration

private extension DiscoverySectionHeaderView {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        backgroundColor = .clear
    }

    func setHierarchy() {
        [
            titleLabel,
            subtitleLabel,
        ].forEach(addSubview)
    }

    func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
}
