import DesignSystem
import SnapKit
import UIKit

/// `SearchResultType.place` 한 줄: 제목 + `[category] · [region]`.
final class PlaceSearchResultCell: UICollectionViewCell {
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

    private let placeCategoryLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.textColor = .dsGrey500
        label.setTypography(.body3M)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private let placeMiddleDotLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.text = "·"
        label.textColor = .dsGrey500
        label.setTypography(.body3M)
        return label
    }()

    private let placeRegionLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.textColor = .dsGrey500
        label.setTypography(.body3M)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private lazy var placeMetaStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                placeCategoryLabel,
                placeMiddleDotLabel,
                placeRegionLabel,
            ]
        )
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        return stackView
    }()

    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                nameLabel,
                placeMetaStackView,
            ]
        )
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
        renderTitle(item.name, searchText: searchText)
        renderMeta(category: item.placeCategory, region: item.placeRegion)
    }
}

// MARK: - Render

private extension PlaceSearchResultCell {
    func renderTitle(_ title: String, searchText: String) {
        nameLabel.attributedText = TextHighlight.primary(text: title, searchText: searchText)
    }

    func renderMeta(category: String, region: String) {
        placeCategoryLabel.isHidden = category.isEmpty
        placeMiddleDotLabel.isHidden = category.isEmpty || region.isEmpty
        placeRegionLabel.isHidden = region.isEmpty

        if !category.isEmpty { placeCategoryLabel.text = category }
        if !region.isEmpty { placeRegionLabel.text = region }
    }
}

// MARK: - UI Configuration

private extension PlaceSearchResultCell {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        contentView.backgroundColor = .clear
    }

    func setHierarchy() {
        [
            iconImageView,
            textStackView,
        ].forEach { contentView.addSubview($0) }
    }

    func setConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
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
