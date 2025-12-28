import DesignSystem
import Domain
import Kingfisher
import RxRelay
import RxSwift
import SnapKit
import UIKit

final class SouvenirCarouselCell: UICollectionViewCell {
    // MARK: - Constants

    private enum Metric {
        static let cornerRadius: CGFloat = 20
        static let imageHeight: CGFloat = 145
        static let closeButtonSize: CGFloat = 32
        static let closeButtonTopTrailing: CGFloat = 12
        static let contentPadding: CGFloat = 20
        static let iconSize: CGFloat = 24
        static let spacing: CGFloat = 8
    }

    // MARK: - UI Components

    // 전체 컨테이너 (회색 배경, 둥근 모서리)
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .dsGrey900
        view.layer.cornerRadius = Metric.cornerRadius
        view.clipsToBounds = true
        return view
    }()

    // 상단 기념품 이미지
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .dsGrey80
        return imageView
    }()

    // 우측 상단 X 닫기 버튼
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(.dsIconCancel, for: .normal)
        button.backgroundColor = .dsGrey900
        button.layer.cornerRadius = Metric.closeButtonSize / 2
        button.clipsToBounds = true
        return button
    }()

    // purpose + name + category를 담는 스택뷰
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()

    // "기념품 목적" (예: 선물용)
    private let purposeLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.textColor = .dsGrey300
        label.numberOfLines = 1
        label.setTypography(.body4M)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()

    // 기념품 이름 (예: "기념품 이름")
    private let nameLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.textColor = .dsGreyWhite
        label.numberOfLines = 1
        label.setTypography(.body1SB)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()

    private let categoryIconView: DSIconTitleView = {
        let view = DSIconTitleView(
            layout: .init(
                iconSize: 16,
                spacing: 4,
                contentInsets: .init(top: 7, left: 12, bottom: 7, right: 12),
                typography: .body4R
            )
        )
        view.setTitleColor(.dsGreyWhite)
        view.backgroundColor = .dsGrey800
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.setContentHuggingPriority(.required, for: .horizontal)
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        return view
    }()

    // 현지 가격 (예: "10달러")
    private let localPriceLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.textColor = .dsMain
        label.numberOfLines = 1
        label.setTypography(.body2SB)
        return label
    }()

    // 원화 환산 가격 (예: "14,775원")
    private let krwPriceLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.textColor = .dsGrey300
        label.numberOfLines = 1
        label.setTypography(.body4M)
        return label
    }()

    // 가격 옆 info 아이콘 버튼
    private let infoButton: UIButton = {
        let button = UIButton()
        button.setImage(.dsIconInformationCircle, for: .normal)
        return button
    }()

    // 주소 정보 (예: "617 N MAIN FALLBROOK CA 92028-1934 USA")
    private let addressLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.textColor = .dsGreyWhite
        label.numberOfLines = 2
        label.setTypography(.body3M)
        return label
    }()

    // MARK: - Properties

    let closeButtonTapped = PublishRelay<Void>()
    var disposeBag = DisposeBag()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Override

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        setBindings()
        imageView.image = nil
        setPriceVisibility(isHidden: true)
    }

    // MARK: - Public

    func render(item: SouvenirListItem) {
        imageView.setFeedImage(item.thumbnail)
        purposeLabel.text = item.purpose.title
        nameLabel.text = item.name
        categoryIconView.render(
            title: item.category.title,
            image: item.category.selectedImage
        )

        // 가격 정보
        let hasPrice = (item.localPrice > 0)
        if hasPrice {
            localPriceLabel.text = item.formattedLocalPrice
            krwPriceLabel.text = item.formattedKrwPrice
        }
        setPriceVisibility(isHidden: !hasPrice)

        addressLabel.text = item.address
    }

    // MARK: - Private

    private func setPriceVisibility(isHidden: Bool) {
        localPriceLabel.isHidden = isHidden
        krwPriceLabel.isHidden = isHidden
        infoButton.isHidden = isHidden
    }
}

// MARK: - UI Configuration

private extension SouvenirCarouselCell {
    func configure() {
        setHierarchy()
        setConstraints()
        setBindings()
    }

    func setHierarchy() {
        contentView.addSubview(containerView)

        [
            imageView,
            closeButton,
            infoStackView,
            localPriceLabel,
            krwPriceLabel,
            infoButton,
            addressLabel,
        ].forEach { containerView.addSubview($0) }

        [
            purposeLabel,
            nameLabel,
            categoryIconView,
        ].forEach { infoStackView.addArrangedSubview($0) }
    }

    func setConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(Metric.imageHeight)
        }

        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Metric.closeButtonTopTrailing)
            make.trailing.equalToSuperview().inset(Metric.closeButtonTopTrailing)
            make.size.equalTo(Metric.closeButtonSize)
        }

        infoStackView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(Metric.contentPadding)
            make.height.equalTo(30)
        }

        localPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(infoStackView.snp.bottom)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(24)
        }

        krwPriceLabel.snp.makeConstraints { make in
            make.leading.equalTo(localPriceLabel.snp.trailing).offset(8)
            make.centerY.equalTo(localPriceLabel)
        }

        infoButton.snp.makeConstraints { make in
            make.leading.equalTo(krwPriceLabel.snp.trailing).offset(15)
            make.centerY.equalTo(localPriceLabel)
            make.size.equalTo(18)
        }

        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(localPriceLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(Metric.contentPadding)
            make.trailing.equalToSuperview().inset(59)
        }
    }

    func setBindings() {
        closeButton.rx.tap
            .bind(to: closeButtonTapped)
            .disposed(by: disposeBag)
    }
}
