import DesignSystem
import SnapKit
import UIKit

final class CategoryChipCell: UICollectionViewCell {
    // MARK: - UI

    private let iconTitleView = DSIconTitleView(
        layout: .init(
            iconSize: 24,
            spacing: 10,
            contentInsets: .init(top: 10, left: 20, bottom: 10, right: 20),
            typography: .body2R
        )
    )

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

    func render(item: CategoryItem) {
        if item.isSelected {
            iconTitleView.render(
                title: item.category.title,
                image: item.category.selectedImage
            )
            iconTitleView.setTitleColor(.dsMain)
            applySelectedStyle()
        } else {
            iconTitleView.render(
                title: item.category.title,
                image: item.category.image
            )
            iconTitleView.setTitleColor(.dsGreyWhite)
            applyDeselectedStyle()
        }
    }

    // MARK: - Private

    private func applySelectedStyle() {
        contentView.backgroundColor = .dsMain.withAlphaComponent(0.1)
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.dsMain.cgColor
    }

    private func applyDeselectedStyle() {
        contentView.backgroundColor = .dsGrey800
        contentView.layer.borderWidth = 0
        contentView.layer.borderColor = nil
    }
}

// MARK: - UI Configuration

private extension CategoryChipCell {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        contentView.backgroundColor = .dsGrey800
        contentView.layer.cornerRadius = 22
        contentView.clipsToBounds = true
    }

    func setHierarchy() {
        contentView.addSubview(iconTitleView)
    }

    func setConstraints() {
        iconTitleView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
