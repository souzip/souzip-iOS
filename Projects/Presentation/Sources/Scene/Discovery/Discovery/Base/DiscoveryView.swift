import DesignSystem
import RxRelay
import RxSwift
import SnapKit
import UIKit

final class DiscoveryView: BaseView<DiscoveryAction> {
    // MARK: - Types

    typealias Section = DiscoverySection
    typealias Item = DiscoveryItem

    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

    // MARK: - UI

    private let naviBar = DSNavigationBar(
        title: "발견",
        style: .title
    )

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: makeCVLayout())
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = false
        view.delegate = self
        return view
    }()

    private let faButton = DSFAButton(image: .dsIconStar)

    // MARK: - Data

    private var dataSource: DataSource?
    private var currentData: DiscoveryData?
    private var isCategoryExpanded: Bool = false

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Override

    override func setAttributes() {
        backgroundColor = .dsBackground
        configureDataSource()
    }

    override func setHierarchy() {
        [
            naviBar,
            collectionView,
            faButton,
        ].forEach(addSubview)
    }

    override func setConstraints() {
        naviBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }

        faButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
        }
    }

    override func setBindings() {
        bind(faButton.rx.tap).to(.tapFAB)
    }

    // MARK: - Public

    func render(_ data: DiscoveryData?, _ isCategoryExpanded: Bool) {
        guard let data else { return }

        currentData = data
        self.isCategoryExpanded = isCategoryExpanded

        var snapshot = Snapshot()

        // Top10 섹션
        if let top10 = data.top10 {
            snapshot.appendSections([.top10CountryChips])
            snapshot.appendItems(
                top10.countryChips.map { .countryChip($0) },
                toSection: .top10CountryChips
            )

            snapshot.appendSections([.top10Cards])
            snapshot.appendItems(
                top10.souvenirCards.map { .souvenirCard($0) },
                toSection: .top10Cards
            )
        }

        // Banner 섹션
        if let banner = data.banner {
            snapshot.appendSections([.banner])
            snapshot.appendItems([.banner(banner.banner)], toSection: .banner)
        }

        // Category 섹션
        if let category = data.category {
            snapshot.appendSections([.categoryChips])
            snapshot.appendItems(
                category.categoryChips.map { .categoryChip($0) },
                toSection: .categoryChips
            )

            snapshot.appendSections([.categoryCards])
            snapshot.appendItems(
                category.souvenirCards.map { .souvenirCard($0) },
                toSection: .categoryCards
            )

            if !isCategoryExpanded {
                snapshot.appendSections([.categoryMore])
                snapshot.appendItems([.moreButton(category.moreButtonTitle)], toSection: .categoryMore)
            }
        }

        // Statistics 섹션
        if let statistics = data.statistics {
            snapshot.appendSections([.statisticsChips])
            snapshot.appendItems(
                [.statCountryChip(statistics.countryChips)],
                toSection: .statisticsChips
            )
        }

        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - Diffable / CellRegistration

private extension DiscoveryView {
    func configureDataSource() {
        let countryChipRegistration = UICollectionView.CellRegistration<
            CountryChipCell,
            CountryChipItem
        > { cell, _, item in
            cell.render(item: item)
        }

        let souvenirCardRegistration = UICollectionView.CellRegistration<
            SouvenirCardCell,
            SouvenirCardItem
        > { cell, _, item in
            cell.render(item: item)
        }

        let bannerRegistration = UICollectionView.CellRegistration<
            BannerCell,
            BannerItem
        > { cell, _, item in
            cell.render(item: item)
        }

        let categoryChipRegistration = UICollectionView.CellRegistration<
            DiscoveryCategoryChipCell,
            CategoryChipItem
        > { cell, _, item in
            cell.render(item: item)
        }

        let moreButtonRegistration = UICollectionView.CellRegistration<
            MoreButtonCell,
            String
        > { cell, _, item in
            cell.render(title: item)
        }

        let rankCardRegistration = UICollectionView.CellRegistration<
            RankCardCell,
            [StatCountryChipItem]
        > { cell, _, item in
            cell.render(item)
        }

        // Header Supplementary Registration
        let headerRegistration = UICollectionView.SupplementaryRegistration<
            DiscoverySectionHeaderView
        >(
            elementKind: UICollectionView.elementKindSectionHeader
        ) { [weak self] supplementaryView, _, indexPath in
            guard let self,
                  let section = dataSource?.sectionIdentifier(for: indexPath.row) else { return }

            let headerItem: SectionHeaderItem? = switch section {
            case .top10CountryChips:
                currentData?.top10?.header
            case .categoryChips:
                currentData?.category?.header
            case .statisticsChips:
                currentData?.statistics?.header
            default:
                nil
            }

            if let headerItem {
                supplementaryView.render(item: headerItem)
            }
        }

        dataSource = .init(
            collectionView: collectionView
        ) { collectionView, indexPath, item in
            switch item {
            case let .countryChip(chipItem):
                collectionView.dequeueConfiguredReusableCell(
                    using: countryChipRegistration,
                    for: indexPath,
                    item: chipItem
                )
            case let .souvenirCard(cardItem):
                collectionView.dequeueConfiguredReusableCell(
                    using: souvenirCardRegistration,
                    for: indexPath,
                    item: cardItem
                )
            case let .banner(bannerItem):
                collectionView.dequeueConfiguredReusableCell(
                    using: bannerRegistration,
                    for: indexPath,
                    item: bannerItem
                )
            case let .categoryChip(chipItem):
                collectionView.dequeueConfiguredReusableCell(
                    using: categoryChipRegistration,
                    for: indexPath,
                    item: chipItem
                )
            case let .moreButton(title):
                collectionView.dequeueConfiguredReusableCell(
                    using: moreButtonRegistration,
                    for: indexPath,
                    item: title
                )
            case let .statCountryChip(chipItem):
                collectionView.dequeueConfiguredReusableCell(
                    using: rankCardRegistration,
                    for: indexPath,
                    item: chipItem
                )
            }
        }

        dataSource?.supplementaryViewProvider = { collectionView, _, indexPath in
            collectionView.dequeueConfiguredReusableSupplementary(
                using: headerRegistration,
                for: indexPath
            )
        }
    }
}

// MARK: - CollectionView Layout

private extension DiscoveryView {
    enum Space {
        static let headerToContent: CGFloat = 12
        static let sameMeaning: CGFloat = 20
        static let differentMeaning: CGFloat = 40
        static let toButton: CGFloat = 23

        static let horizontal: CGFloat = 20
    }

    func makeCVLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self,
                  let kind = dataSource?.sectionIdentifier(for: sectionIndex)
            else { return nil }

            let section = switch kind {
            case .top10CountryChips: makeTop10ChipsSectionLayout()
            case .top10Cards: makeTop10CardsSectionLayout()
            case .banner: makeBannerSectionLayout()
            case .categoryChips: makeCategoryChipsSectionLayout()
            case .categoryCards: makeCategoryCardsSectionLayout()
            case .categoryMore: makeCategoryMoreSectionLayout()
            case .statisticsChips: makeStatisticsChipsSectionLayout()
            }

            section.contentInsets.top = topSpacing(for: kind)
            section.contentInsets.bottom = bottomSpacing(for: kind)

            switch kind {
            case .banner, .statisticsChips:
                section.contentInsets.leading = 0
                section.contentInsets.trailing = 0
            default:
                section.contentInsets.leading = Space.horizontal
                section.contentInsets.trailing = Space.horizontal
            }

            return section
        }
    }

    func topSpacing(for kind: Section) -> CGFloat {
        switch kind {
        case .top10CountryChips:
            Space.headerToContent
        case .top10Cards:
            Space.sameMeaning
        case .banner:
            Space.differentMeaning
        case .categoryChips:
            Space.headerToContent
        case .categoryCards:
            Space.sameMeaning
        case .categoryMore:
            Space.toButton
        case .statisticsChips:
            17
        }
    }

    func bottomSpacing(for kind: Section) -> CGFloat {
        switch kind {
        case .banner: 40
        case .categoryMore: 40
        case .categoryCards:
            isCategoryExpanded ? 40 : 0
        case .statisticsChips: 68
        default: 0
        }
    }
}

private extension DiscoveryView {
    // Top10 국가 칩 섹션 (헤더 + 가로 스크롤 칩)
    func makeTop10ChipsSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(80),
            heightDimension: .absolute(40)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(80),
            heightDimension: .absolute(40)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 6

        // 헤더 추가
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(62)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]

        return section
    }

    // Top10 카드 섹션 (가로 스크롤)
    func makeTop10CardsSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(164),
            heightDimension: .estimated(219)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(164),
            heightDimension: .estimated(219)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 8
        return section
    }

    // 배너 섹션
    func makeBannerSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(106)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(106)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        return section
    }

    // Category 칩 섹션 (헤더 + 가로 스크롤)
    func makeCategoryChipsSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(100),
            heightDimension: .absolute(30)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(100),
            heightDimension: .absolute(30)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 8

        // 헤더 추가
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(62)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
        section.contentInsets = .init(top: 8, leading: 0, bottom: 0, trailing: 0)

        return section
    }

    // Category 카드 섹션 (2열 그리드)
    func makeCategoryCardsSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .estimated(234)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(234)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item, item]
        )
        group.interItemSpacing = .fixed(8)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 23
        return section
    }

    // Category 더보기 버튼 섹션
    func makeCategoryMoreSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(34)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(34)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        return section
    }

    // Statistics 칩 섹션 (헤더 + Flexible Wrap)
    func makeStatisticsChipsSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(250)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(250)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)

        // 헤더 추가
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(80)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        header.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)

        section.boundarySupplementaryItems = [header]
        return section
    }
}

// MARK: - UICollectionView Delegate

extension DiscoveryView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource?.itemIdentifier(for: indexPath) else { return }

        switch item {
        case let .countryChip(chipItem):
            action.accept(.countryChipTap(chipItem))
        case let .souvenirCard(cardItem):
            action.accept(.souvenirCardTap(cardItem))
        case let .categoryChip(chipItem):
            action.accept(.categoryChipTap(chipItem))
        case .moreButton:
            action.accept(.moreButtonTap)
        default:
            break
        }
    }
}
