import DesignSystem
import SnapKit
import UIKit

final class SearchResultCell: UICollectionViewCell {
    // MARK: - UI

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
        return label
    }()

    private let subNameLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.textColor = .dsGrey500
        label.setTypography(.body3M)
        return label
    }()

    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, subNameLabel])
        stackView.axis = .vertical
        stackView.spacing = 3
        stackView.alignment = .leading
        return stackView
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

    // MARK: - Configure

    private func configure() {
        setHierarchy()
        setConstraints()
    }

    private func setHierarchy() {
        [
            iconImageView,
            textStackView,
        ].forEach {
            contentView.addSubview($0)
        }
    }

    private func setConstraints() {
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

    // MARK: - Public

    func render(item: SearchResultItem, searchText: String) {
        nameLabel.attributedText = highlight(text: item.name, searchText: searchText)

        switch item.type {
        case .country:
            subNameLabel.isHidden = true

        case .city:
            subNameLabel.isHidden = false
            subNameLabel.text = item.subName
        }
    }

    // MARK: - Private

    private func highlight(text: String, searchText: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(
            string: text,
            attributes: Typography.body1SB.toAttributes().merging([.foregroundColor: UIColor.dsGreyWhite]) { $1 }
        )

        guard !searchText.isEmpty else { return attributedString }

        let range = (text as NSString).range(of: searchText, options: .caseInsensitive)
        if range.location != NSNotFound {
            attributedString.addAttribute(
                .foregroundColor,
                value: UIColor.dsMain,
                range: range
            )
        }

        return attributedString
    }
}
