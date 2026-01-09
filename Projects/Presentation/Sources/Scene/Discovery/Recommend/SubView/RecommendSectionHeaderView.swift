import DesignSystem
import SnapKit
import UIKit

final class RecommendSectionHeaderView: UICollectionReusableView {
    // MARK: - UI

    private let titleLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.textColor = .dsGreyWhite
        label.numberOfLines = 0
        label.setTypography(.body1SB)
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

    func render(title: String) {
        titleLabel.text = title
        titleLabel.isHidden = title.isEmpty
    }
}

// MARK: - UI Configuration

private extension RecommendSectionHeaderView {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        backgroundColor = .clear
    }

    func setHierarchy() {
        addSubview(titleLabel)
    }

    func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
