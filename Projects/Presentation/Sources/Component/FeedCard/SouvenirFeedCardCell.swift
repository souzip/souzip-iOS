import DesignSystem
import Kingfisher
import SnapKit
import UIKit

final class SouvenirFeedCardCell: UICollectionViewCell {
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

    private let heartButton: UIButton = {
        let button = UIButton(type: .custom)
        button.isUserInteractionEnabled = false
        return button
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

    // MARK: - Override

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        imageView.kf.cancelDownloadTask()
        heartButton.setImage(nil, for: .normal)
    }

    // MARK: - Public

    func render(item: SouvenirFeedCardItem) {
        imageView.setFeedImage(item.imageURL)
        titleLabel.text = item.title
        categoryLabel.text = item.categoryTitle
        let heartImage: UIImage = item.isWishlisted == true ? .dsIconHeartFilled : .dsIconHeart
        heartButton.setImage(heartImage, for: .normal)
    }
}

// MARK: - UI Configuration

private extension SouvenirFeedCardCell {
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
            heartButton,
        ].forEach(contentView.addSubview)
    }

    func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(imageView.snp.width)
        }

        heartButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.trailing.equalToSuperview().inset(8)
            make.width.height.equalTo(24)
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
