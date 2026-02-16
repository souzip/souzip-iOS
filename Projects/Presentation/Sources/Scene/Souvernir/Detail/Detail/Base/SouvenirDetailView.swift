import CoreLocation
import DesignSystem
import Domain
import Kingfisher
import SnapKit
import UIKit

final class SouvenirDetailView: BaseView<SouvenirDetailAction> {
    // MARK: - Types

    private enum Section {
        case main
    }

    // MARK: - UI

    private let naviBar = DSNavigationBar(
        title: "",
        style: .back
    )

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()

    private let contentView = UIView()

    // 이미지 슬라이더
    private lazy var imageCollectionView: UICollectionView = {
        let layout = createImageLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        return cv
    }()

    private let pageControl = DSPageControl()

    // 소유자 정보
    private let ownerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .center
        return stack
    }()

    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .clear
        iv.layer.cornerRadius = 28
        iv.clipsToBounds = true
        iv.setContentHuggingPriority(.required, for: .horizontal)
        iv.setContentCompressionResistancePriority(.required, for: .horizontal)
        return iv
    }()

    private let usernameLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.textColor = .dsGreyWhite
        label.setTypography(.body1R)
        return label
    }()

    private let purposeLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.textColor = .dsGrey300
        label.setTypography(.body4M)
        return label
    }()

    // 이름 & 카테고리
    private let nameCategoryStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        return stack
    }()

    // 제목
    private let nameLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.setTypography(.body1SB)
        label.textColor = .dsGreyWhite
        label.numberOfLines = 1
        return label
    }()

    private let categoryView: DSIconTitleView = {
        let view = DSIconTitleView(
            layout: .init(
                iconSize: 16,
                spacing: 4,
                contentInsets: .init(top: 7, left: 12, bottom: 7, right: 12),
                typography: .body4R
            )
        )
        view.backgroundColor = .dsGrey800
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.setContentHuggingPriority(.required, for: .horizontal)
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        return view
    }()

    // 가격
    private let priceContainerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        return stack
    }()

    private let localPriceLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.setTypography(.subhead24SB)
        label.textColor = .dsMain
        return label
    }()

    private let krwPriceLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.setTypography(.body4M)
        label.textColor = .dsGrey300
        return label
    }()

    // 설명
    private let descriptionLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.setTypography(.body2R)
        label.textColor = .dsGreyWhite
        label.numberOfLines = 0
        return label
    }()

    // 위치 섹션
    private let locationTitleLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.text = "위치"
        label.setTypography(.body2SB)
        label.textColor = .dsGreyWhite
        return label
    }()

    private let addressLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.textColor = .dsGreyWhite
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.setTypography(.body2M)
        return label
    }()

    private let locationDetailLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.textColor = .dsGrey300
        label.numberOfLines = 0
        label.setTypography(.body4R)
        return label
    }()

    private let copyAddressButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = .dsIconLinkSelected
        config.imagePadding = 0
        config.contentInsets = .init(
            top: 6,
            leading: 8,
            bottom: 6,
            trailing: 8
        )
        config.baseForegroundColor = .dsMain
        config.background.backgroundColor = .dsGrey800
        config.background.cornerRadius = 2
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 20)

        config.setTypography(.body4M, title: "복사")
        let button = UIButton(configuration: config)
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        return button
    }()

    private var mapView: LocationMapView?

    // MARK: - Diffable DataSource

    private var dataSource: UICollectionViewDiffableDataSource<Section, String>?

    // MARK: - Properties

    private var currentDetail: SouvenirDetail?

    // MARK: - Override

    override func setAttributes() {
        backgroundColor = .dsBackground
        setupDataSource()

        mapView?.layer.cornerRadius = 10
        mapView?.clipsToBounds = true
    }

    override func setHierarchy() {
        addSubview(naviBar)
        addSubview(scrollView)
        scrollView.addSubview(contentView)

        [
            imageCollectionView,
            pageControl,
            ownerStackView,
            purposeLabel,
            nameCategoryStack,
            priceContainerStack,
            descriptionLabel,
            locationTitleLabel,
            addressLabel,
            locationDetailLabel,
            copyAddressButton,
        ].forEach(contentView.addSubview)

        [
            profileImageView,
            usernameLabel,
        ].forEach(ownerStackView.addArrangedSubview)

        [
            nameLabel,
            categoryView,
        ].forEach(nameCategoryStack.addArrangedSubview)

        [
            localPriceLabel,
            krwPriceLabel,
        ].forEach(priceContainerStack.addArrangedSubview)
    }

    override func setConstraints() {
        naviBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }

        imageCollectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(imageCollectionView.snp.width)
        }

        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(imageCollectionView).offset(-13)
            make.centerX.equalToSuperview()
        }

        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(56)
        }

        ownerStackView.snp.makeConstraints { make in
            make.top.equalTo(imageCollectionView.snp.bottom).offset(15)
            make.horizontalEdges.equalToSuperview().inset(20)
        }

        purposeLabel.snp.makeConstraints { make in
            make.top.equalTo(ownerStackView.snp.bottom).offset(15)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(18)
        }

        nameCategoryStack.snp.makeConstraints { make in
            make.top.equalTo(purposeLabel.snp.bottom)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }

        categoryView.snp.makeConstraints { make in
            make.height.equalTo(30)
        }

        priceContainerStack.snp.makeConstraints { make in
            make.top.equalTo(nameCategoryStack.snp.bottom)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(36)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(priceContainerStack.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(20)
        }

        locationTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(45)
            make.leading.equalToSuperview().inset(20)
        }

        locationTitleLabel.snp.makeConstraints { make in
            make.bottom.lessThanOrEqualToSuperview().inset(20)
        }
    }

    override func setBindings() {
        bind(naviBar.onLeftTap).to(.back)

        bind(naviBar.onRightTap).map { rightAction in
            switch rightAction {
            case .edit: .edit
            case .delete: .delete
            case .etc: .etc
            default: .back
            }
        }

        bind(copyAddressButton.rx.tap).to(.tapCopy)
    }

    // MARK: - Public

    func render(detail: SouvenirDetail) {
        currentDetail = detail

        // 네비게이션 바
        let navStyle: DSNavigationBar.Style = detail.isOwned ? .backManage : .backEtc
        naviBar.render(title: "", style: navStyle)

        // 이미지
        renderImages(detail.imageUrls)

        // 소유자

        if detail.isOwned {
            profileImageView.isHidden = true
            usernameLabel.isHidden = true
        } else {
            profileImageView.setStaticAsset(detail.owner.profileImageUrl)
            usernameLabel.text = detail.owner.nickname
        }

        // 목적
        purposeLabel.text = detail.purpose.title

        // 제목
        nameLabel.text = detail.name

        // 카테고리
        categoryView.render(
            title: detail.category.title,
            image: detail.category.selectedImage
        )

        // 가격 (둘 다 있을 때만 표시)
        if let localPrice = detail.localPrice,
           let symbol = detail.currencySymbol,
           let krwPrice = detail.krwPrice {
            priceContainerStack.isHidden = false
            localPriceLabel.text = "\(symbol) \(formatKRW(localPrice))"
            krwPriceLabel.text = "\(formatKRW(krwPrice))원"
        } else {
            priceContainerStack.isHidden = true
        }

        // 설명
        descriptionLabel.text = detail.description

        // 지도 생성 및 레이아웃
        if mapView == nil {
            let coordinate = CLLocationCoordinate2D(
                latitude: detail.coordinate.latitude,
                longitude: detail.coordinate.longitude
            )
            let map = LocationMapView(mode: .readonly, initialCoordinate: coordinate)
            contentView.addSubview(map)
            mapView = map
            mapView?.layer.cornerRadius = 10
            mapView?.clipsToBounds = true

            map.snp.makeConstraints { make in
                make.top.equalTo(locationTitleLabel.snp.bottom).offset(8)
                make.horizontalEdges.equalToSuperview().inset(20)
                make.height.equalTo(map.snp.width).multipliedBy(154.0 / 335.0)
            }

            addressLabel.snp.makeConstraints { make in
                make.top.equalTo(map.snp.bottom).offset(12)
                make.leading.equalToSuperview().inset(20)
                make.trailing.lessThanOrEqualTo(copyAddressButton.snp.leading).offset(-5)
                make.height.equalTo(32)
            }

            copyAddressButton.snp.makeConstraints { make in
                make.centerY.equalTo(addressLabel)
                make.trailing.equalToSuperview().inset(20)
                make.height.equalTo(32)
            }

            locationDetailLabel.snp.makeConstraints { make in
                make.top.equalTo(addressLabel.snp.bottom).offset(8)
                make.horizontalEdges.equalToSuperview().inset(20)
                make.bottom.equalToSuperview().inset(24)
            }
        }

        // 주소 텍스트
        addressLabel.text = detail.address

        // 위치 상세
        if let locationDetail = detail.locationDetail {
            locationDetailLabel.isHidden = false
            locationDetailLabel.text = locationDetail
        } else {
            locationDetailLabel.isHidden = true
        }
    }

    // MARK: - Private

    private func setupDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<
            UICollectionViewCell,
            String
        > { cell, _, imageUrl in
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true

            cell.contentView.subviews.forEach { $0.removeFromSuperview() }
            cell.contentView.addSubview(imageView)

            imageView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }

            imageView.setDetailImage(imageUrl)
        }

        dataSource = UICollectionViewDiffableDataSource<Section, String>(
            collectionView: imageCollectionView
        ) { collectionView, indexPath, item in
            collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: item
            )
        }
    }

    private func createImageLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging

        section.visibleItemsInvalidationHandler = { [weak self] _, contentOffset, environment in
            guard let self else { return }

            let pageWidth = environment.container.contentSize.width
            guard pageWidth > 0 else { return }

            let page = Int((contentOffset.x + pageWidth / 2) / pageWidth)
            pageControl.currentPage = page
        }

        return UICollectionViewCompositionalLayout(section: section)
    }

    private func renderImages(_ urls: [String]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.main])
        snapshot.appendItems(urls)
        dataSource?.apply(snapshot, animatingDifferences: false)

        pageControl.numberOfPages = urls.count
        pageControl.currentPage = 0
    }

    private func formatKRW(_ value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}
