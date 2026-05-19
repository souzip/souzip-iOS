import DesignSystem
import Kingfisher
import RxRelay
import RxSwift
import SnapKit
import UIKit

final class SouvenirFeedCardCell: UICollectionViewCell, ActionBindable {
    enum Action {
        case heartTap
    }

    let action = PublishRelay<Action>()
    var disposeBag = DisposeBag()

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

    private let heartButton: UIButton = .init(type: .custom)

    /// Diffable 재구성 시 `render`가 다시 불려도 동일 URL이면 Kingfisher 재로드를 막는다.
    private var renderedImageURL: String?

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
        renderedImageURL = nil
        imageView.image = nil
        imageView.kf.cancelDownloadTask()
        heartButton.setImage(nil, for: .normal)
        disposeBag = DisposeBag()
        setBindings()
    }

    // MARK: - Public

    func render(item: SouvenirFeedCardItem) {
        if renderedImageURL != item.imageURL {
            renderedImageURL = item.imageURL
            imageView.setFeedImage(item.imageURL)
        }
        titleLabel.text = item.title
        categoryLabel.text = item.categoryTitle
        updateWishlistAppearance(isWishlisted: item.isWishlisted)
    }

    /// 찜 토글 등 하트만 바뀔 때 이미지·텍스트 재로드 없이 아이콘만 갱신한다.
    func updateWishlistAppearance(isWishlisted: Bool?) {
        let heartImage: UIImage = isWishlisted == true ? .dsIconHeartFilled : .dsIconHeart
        heartButton.setImage(heartImage, for: .normal)
    }
}

// MARK: - UI Configuration

private extension SouvenirFeedCardCell {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
        setBindings()
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

    func setBindings() {
        bind(heartButton.rx.tap).to(.heartTap)
    }
}
