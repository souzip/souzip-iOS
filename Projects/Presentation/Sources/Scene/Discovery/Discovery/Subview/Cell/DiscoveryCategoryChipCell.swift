import DesignSystem
import SnapKit
import UIKit

final class DiscoveryCategoryChipCell: UICollectionViewCell {
    // MARK: - UI

    private let iconImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()

    private let titleLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.setTypography(.body4R)
        label.textColor = .dsGreyWhite
        return label
    }()

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .center
        return stack
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

    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
    }

    // MARK: - Public

    func render(item: CategoryItem) {
        iconImageView.image = item.category.selectedImage
        titleLabel.text = item.category.title

        if item.isSelected {
            applySelectedStyle()
        } else {
            applyDeselectedStyle()
        }
    }

    // MARK: - Private

    private func applySelectedStyle() {
        contentView.backgroundColor = .dsMain.withAlphaComponent(0.1)
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.dsMain.cgColor
        titleLabel.textColor = .dsMain
    }

    private func applyDeselectedStyle() {
        contentView.backgroundColor = .dsGrey700
        contentView.layer.borderWidth = 0
        contentView.layer.borderColor = nil
        titleLabel.textColor = .dsGreyWhite
    }
}

// MARK: - UI Configuration

private extension DiscoveryCategoryChipCell {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        contentView.backgroundColor = .dsGrey700
        contentView.layer.cornerRadius = 17
        contentView.clipsToBounds = true
    }

    func setHierarchy() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(titleLabel)
    }

    func setConstraints() {
        stackView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(8)
            make.horizontalEdges.equalToSuperview().inset(12)
        }

        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(16)
        }
    }
}
