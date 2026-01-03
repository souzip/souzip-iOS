import DesignSystem
import Kingfisher
import SnapKit
import UIKit

final class SouvenirCardCell: UICollectionViewCell {
    // MARK: - UI

    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .dsGrey80
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }()

    private let titleLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.setTypography(.body2M)
        label.textColor = .dsGreyWhite
        label.numberOfLines = 1
        return label
    }()

    private let categoryLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.textColor = .dsGrey300
        label.numberOfLines = 1
        label.setTypography(.body3M)
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

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        imageView.kf.cancelDownloadTask()
    }

    // MARK: - Public

    func render(item: SouvenirCardItem) {
        imageView.setFeedImage(item.imageURL)
        titleLabel.text = item.title
        categoryLabel.text = item.category
    }
}

// MARK: - UI Configuration

private extension SouvenirCardCell {
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
            imageView,
            titleLabel,
            categoryLabel,
        ].forEach(contentView.addSubview)
    }

    func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(imageView.snp.width)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(24)
        }

        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(21)
        }
    }
}
