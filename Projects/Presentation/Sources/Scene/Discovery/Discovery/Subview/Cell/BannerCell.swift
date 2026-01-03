import DesignSystem
import SnapKit
import UIKit

final class BannerCell: UICollectionViewCell {
    // MARK: - UI

    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
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

    func render(item: BannerItem) {
        imageView.setFeedImage(item.imageURL)
    }
}

// MARK: - UI Configuration

private extension BannerCell {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        contentView.backgroundColor = .dsGreyWhite
    }

    func setHierarchy() {
        contentView.addSubview(imageView)
    }

    func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
