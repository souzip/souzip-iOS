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
        view.refreshControl = refreshContorl
        view.contentInset.top = 18
        return view
    }()

    private let refreshContorl = UIRefreshControl()

    private let faButton = DSFAButton(image: .dsIconStar)

    // MARK: - Data

    private var dataSource: DataSource?

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
        bind(refreshContorl.rx.controlEvent(.valueChanged)).to(.refresh)

        bind(collectionView.rx.itemSelected)
            .compactMap { [weak self] indexPath -> DiscoveryAction? in
                guard let item = self?.dataSource?.itemIdentifier(for: indexPath) else { return nil }
                switch item {
                case let .countryChip(chipItem): return .countryChipTap(chipItem)
                case let .souvenirCard(cardItem): return .souvenirCardTap(cardItem)
                case let .categoryChip(chipItem): return .categoryChipTap(chipItem)
                case .moreButton: return .moreButtonTap
                default: return nil
                }
            }
    }

    // MARK: - Public

    func renderSectionModels(_ sectionModels: [DiscoverySectionModel]) {
        var snapshot = Snapshot()
        var appended = Set<Section>()

        for model in sectionModels {
            if appended.contains(model.section) == false {
                snapshot.appendSections([model.section])
                appended.insert(model.section)
            }
            snapshot.appendItems(model.items, toSection: model.section)
        }

        dataSource?.apply(snapshot, animatingDifferences: true)
    }

    func renderIsGuest(_ isGuest: Bool) {
        faButton.isHidden = isGuest
    }

    func endRefreshing() {
        refreshContorl.endRefreshing()
    }
}

// MARK: - Diffable / CellRegistration

private struct DiscoveryCellRegistrations {
    let countryChip: UICollectionView.CellRegistration<CountryChipCell, CountryChipItem>
    let souvenirCard: UICollectionView.CellRegistration<SouvenirCardCell, SouvenirCardItem>
    let categoryChip: UICollectionView.CellRegistration<DiscoveryCategoryChipCell, CategoryItem>
    let moreButton: UICollectionView.CellRegistration<MoreButtonCell, String>
    let rankCard: UICollectionView.CellRegistration<RankCardCell, [StatCountryChipItem]>
    let empty: UICollectionView.CellRegistration<EmptyStateCell, String>
    let spacer: UICollectionView.CellRegistration<UICollectionViewCell, Void>
    let banner: UICollectionView.CellRegistration<BannerCell, Void>
    let header: UICollectionView.SupplementaryRegistration<DiscoverySectionHeaderView>
}

private extension DiscoveryView {
    func makeCellRegistrations() -> DiscoveryCellRegistrations {
        DiscoveryCellRegistrations(
            countryChip: .init { cell, _, item in
                cell.render(item: item)
            },
            souvenirCard: .init { cell, _, item in
                cell.render(item: item)
            },
            categoryChip: .init { cell, _, item in
                cell.render(item: item)
            },
            moreButton: .init { cell, _, item in
                cell.render(title: item)
            },
            rankCard: .init { cell, _, item in
                cell.render(item)
            },
            empty: .init { cell, _, text in
                cell.render(text)
            },
            spacer: .init { _, _, _ in },
            banner: .init { [weak self] cell, _, _ in
                guard let viewController = self?.window?.rootViewController else { return }
                cell.configure(rootViewController: viewController)
            },
            header: .init(
                elementKind: UICollectionView.elementKindSectionHeader
            ) { [weak self] supplementaryView, _, indexPath in
                guard let self,
                      let section = dataSource?.sectionIdentifier(for: indexPath.section)
                else { return }

                supplementaryView.render(section: section)
            }
        )
    }

    func dequeueConfiguredCell(
        collectionView: UICollectionView,
        indexPath: IndexPath,
        item: Item,
        registrations: DiscoveryCellRegistrations
    ) -> UICollectionViewCell {
        switch item {
        case let .countryChip(chipItem):
            collectionView.dequeueConfiguredReusableCell(
                using: registrations.countryChip,
                for: indexPath,
                item: chipItem
            )

        case let .souvenirCard(cardItem):
            collectionView.dequeueConfiguredReusableCell(
                using: registrations.souvenirCard,
                for: indexPath,
                item: cardItem
            )

        case let .categoryChip(chipItem):
            collectionView.dequeueConfiguredReusableCell(
                using: registrations.categoryChip,
                for: indexPath,
                item: chipItem
            )

        case let .moreButton(title):
            collectionView.dequeueConfiguredReusableCell(
                using: registrations.moreButton,
                for: indexPath,
                item: title
            )

        case let .statCountryChip(chipItem):
            collectionView.dequeueConfiguredReusableCell(
                using: registrations.rankCard,
                for: indexPath,
                item: chipItem
            )

        case let .empty(_, text):
            collectionView.dequeueConfiguredReusableCell(
                using: registrations.empty,
                for: indexPath,
                item: text
            )

        case .banner:
            collectionView.dequeueConfiguredReusableCell(
                using: registrations.banner,
                for: indexPath,
                item: ()
            )

        case .spacer:
            collectionView.dequeueConfiguredReusableCell(
                using: registrations.spacer,
                for: indexPath,
                item: ()
            )
        }
    }

    func configureDataSource() {
        let registrations = makeCellRegistrations()

        dataSource = .init(
            collectionView: collectionView
        ) { [weak self] collectionView, indexPath, item in
            guard let self else { return UICollectionViewCell() }
            return dequeueConfiguredCell(
                collectionView: collectionView,
                indexPath: indexPath,
                item: item,
                registrations: registrations
            )
        }

        dataSource?.supplementaryViewProvider = { collectionView, _, indexPath in
            collectionView.dequeueConfiguredReusableSupplementary(
                using: registrations.header,
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

    func isSectionEmpty(_ kind: Section) -> Bool {
        guard let dataSource else { return false }
        let items = dataSource.snapshot().itemIdentifiers(inSection: kind)
        guard items.count == 1 else { return false }
        if case .empty = items[0] { return true }
        return false
    }

    func sectionLayout(for kind: Section, isEmptySection: Bool) -> NSCollectionLayoutSection {
        switch kind {
        case .top10CountryChips:
            makeTop10ChipsSectionLayout()

        case .top10Cards:
            if isEmptySection {
                makeEmptyFullWidthSectionLayout(height: 219)
            } else {
                makeTop10CardsSectionLayout()
            }

        case .banner:
            makeBannerSectionLayout()

        case .categoryChips:
            makeCategoryChipsSectionLayout()

        case .categoryCards:
            if isEmptySection {
                makeEmptyFullWidthSectionLayout(height: 219)
            } else {
                makeCategoryCardsSectionLayout()
            }

        case .categoryMore:
            makeCategoryMoreSectionLayout()

        case .statisticsChips:
            makeStatisticsChipsSectionLayout()

        case .spacer:
            makeSpacerSectionLayout()
        }
    }

    func makeCVLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self,
                  let kind = dataSource?.sectionIdentifier(for: sectionIndex)
            else { return nil }

            let isEmptySection = isSectionEmpty(kind)
            let section = sectionLayout(for: kind, isEmptySection: isEmptySection)

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
        case .spacer:
            0
        }
    }

    func bottomSpacing(for kind: Section) -> CGFloat {
        switch kind {
        case .statisticsChips:
            68
        case .banner:
            40
        default:
            0
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

    // 배너 섹션
    func makeBannerSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(60)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(60)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        return NSCollectionLayoutSection(group: group)
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

    // Category 칩 섹션 (헤더 + 가로 스크롤)
    func makeCategoryChipsSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(100),
            heightDimension: .absolute(34)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(100),
            heightDimension: .absolute(34)
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

        return NSCollectionLayoutSection(group: group)
    }

    // Statistics 섹션
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

    func makeEmptyFullWidthSectionLayout(height: CGFloat) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(height)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = itemSize
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        return NSCollectionLayoutSection(group: group)
    }

    func makeSpacerSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(40)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = itemSize
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        return NSCollectionLayoutSection(group: group)
    }
}
