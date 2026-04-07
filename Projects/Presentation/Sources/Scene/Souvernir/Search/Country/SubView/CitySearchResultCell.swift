import DesignSystem
import SnapKit
import UIKit

/// `SearchResultDetail.city` 한 줄: 제목 + 국가(부제).
final class CitySearchResultCell: UICollectionViewCell {
    // MARK: - UI Components

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .dsIconPin
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        imageView.backgroundColor = .dsGrey700
        return imageView
    }()

    private let nameLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.textColor = .dsGreyWhite
        label.setTypography(.body1R)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private let subNameLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.textColor = .dsGrey500
        label.setTypography(.body3M)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, subNameLabel])
        stackView.axis = .vertical
        stackView.spacing = 3
        stackView.alignment = .leading
        return stackView
    }()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public

    func render(item: SearchResultItem, searchText: String) {
        nameLabel.attributedText = TextHighlight.primary(text: item.name, searchText: searchText)
        if case let .city(subName) = item.detail {
            let trimmed = subName.trimmingCharacters(in: .whitespacesAndNewlines)
            subNameLabel.isHidden = trimmed.isEmpty
            subNameLabel.text = trimmed.isEmpty ? nil : trimmed
        } else {
            subNameLabel.isHidden = true
            subNameLabel.text = nil
        }
    }

    func renderSelected(_ isSelected: Bool) {
        if isSelected {
            contentView.backgroundColor = .dsGrey800
            contentView.layer.borderWidth = 1
            contentView.layer.borderColor = UIColor.dsGrey500.cgColor
        } else {
            contentView.backgroundColor = .clear
            contentView.layer.borderWidth = 0
            contentView.layer.borderColor = nil
        }
    }
}

// MARK: - UI Configuration

private extension CitySearchResultCell {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
    }

    func setHierarchy() {
        [
            iconImageView,
            textStackView,
        ].forEach { contentView.addSubview($0) }
    }

    func setConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
            make.size.equalTo(54)
        }

        textStackView.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(16)
            make.trailing.lessThanOrEqualToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}
