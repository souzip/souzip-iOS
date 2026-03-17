import DesignSystem
import Domain
import SnapKit
import UIKit

final class NoticeListCell: UICollectionViewCell {
    // MARK: - UI

    private let dateLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.textColor = .dsGrey300
        label.setTypography(.body4R)
        return label
    }()

    private let titleLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .dsGreyWhite
        label.setTypography(.body2R)
        label.numberOfLines = 2
        return label
    }()

    private let chevronImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = .dsIconChevronRight.withRenderingMode(.alwaysTemplate)
        iv.tintColor = .dsGrey300
        return iv
    }()

    private let labelStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 2
        sv.alignment = .fill
        return sv
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

    func render(item: Notice) {
        dateLabel.text = Self.formatDate(item.createdAt)
        titleLabel.text = item.title
    }
}

// MARK: - UI Configuration

private extension NoticeListCell {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        contentView.backgroundColor = .clear
        // label이 chevron을 밀지 않도록 수평 압축 저항을 낮춤 (기본값 750 → 250)
        labelStackView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }

    func setHierarchy() {
        [
            dateLabel,
            titleLabel,
        ].forEach(labelStackView.addArrangedSubview)

        [
            labelStackView,
            chevronImageView,
        ].forEach(contentView.addSubview)
    }

    func setConstraints() {
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(85)
        }

        chevronImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.size.equalTo(24)
        }

        labelStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalTo(chevronImageView.snp.leading).offset(-20)
            make.centerY.equalToSuperview()
        }
    }
}

// MARK: - Private

private extension NoticeListCell {
    static func formatDate(_ isoString: String) -> String {
        String(isoString.prefix(10)).replacingOccurrences(of: "-", with: ". ")
    }
}
