import DesignSystem
import RxRelay
import RxSwift
import SnapKit
import UIKit

final class RecommendView: BaseView<RecommendAction> {
    // MARK: - Types

    typealias Section = RecommendSection
    typealias Item = RecommendItem
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

    // MARK: - UI

    private let naviBar = DSNavigationBar(
        title: "AI추천",
        style: .back
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
    }

    override func setBindings() {
        bind(naviBar.onLeftTap).to(.back)
        bind(refreshContorl.rx.controlEvent(.valueChanged)).to(.refresh)

        bind(collectionView.rx.itemSelected)
            .compactMap { [weak self] indexPath -> RecommendAction? in
                guard let self, let item = dataSource?.itemIdentifier(for: indexPath) else { return nil }
                switch item {
                case let .countryChip(countryItem):
                    return .countryChipTap(.init(
                        countryCode: countryItem.countryCode,
                        title: countryItem.title,
                        flagImage: countryItem.flagImage,
                        isSelected: countryItem.isSelected
                    ))

                case let .souvenirCard(cardItem): return .souvenirCardTap(cardItem)

                case .uploadPrompt: return .uploadButtonTap

                case .moreButton:
                    guard let section = dataSource?.sectionIdentifier(for: indexPath.section) else { return nil }
                    switch section {
                    case .preferredMore: return .preferredMoreTap
                    case .uploadMore: return .uploadMoreTap
                    default: return nil
                    }

                default: return nil
                }
            }
    }

    // MARK: - Public

    func render(_ sections: [RecommendSectionModel]) {
        var snapshot = Snapshot()
        var appended = Set<Section>()

        for model in sections {
            if appended.contains(model.section) == false {
                snapshot.appendSections([model.section])
                appended.insert(model.section)
            }
            snapshot.appendItems(model.items, toSection: model.section)
        }

        dataSource?.apply(snapshot, animatingDifferences: true)
    }

    func endRefreshing() {
        refreshContorl.endRefreshing()
    }
}

// MARK: - DataSource Configuration

private struct RecommendCellRegistrations {
    let countryChip: UICollectionView.CellRegistration<CountryChipCell, CountryChipItem>
    let souvenirCard: UICollectionView.CellRegistration<SouvenirCardCell, SouvenirCardItem>
    let moreButton: UICollectionView.CellRegistration<MoreButtonCell, String>
    let uploadPrompt: UICollectionView.CellRegistration<UploadPromptCell, Void>
    let spacer: UICollectionView.CellRegistration<UICollectionViewCell, Void>
    let empty: UICollectionView.CellRegistration<EmptyStateCell, String>
    let header: UICollectionView.SupplementaryRegistration<RecommendSectionHeaderView>
}

private extension RecommendView {
    func makeCellRegistrations() -> RecommendCellRegistrations {
        RecommendCellRegistrations(
            countryChip: .init { cell, _, item in
                cell.render(item: item)
            },
            souvenirCard: .init { cell, _, item in
                cell.render(item: item)
            },
            moreButton: .init { cell, _, title in
                cell.render(title: title)
            },
            uploadPrompt: .init { [weak self] cell, _, _ in
                cell.action
                    .bind { [weak self] in
                        self?.action.accept(.uploadButtonTap)
                    }
                    .disposed(by: cell.disposeBag)
            },
            spacer: .init { _, _, _ in },
            empty: .init { cell, _, text in
                cell.render(text)
            },
            header: .init(
                elementKind: UICollectionView.elementKindSectionHeader
            ) { [weak self] supplementaryView, _, indexPath in
                guard let self,
                      let section = dataSource?.sectionIdentifier(for: indexPath.section)
                else { return }

                switch section {
                case .preferredMore, .uploadMore, .uploadEmpty, .spacer:
                    supplementaryView.isHidden = true
                    supplementaryView.render(title: "")

                default:
                    supplementaryView.isHidden = false
                    supplementaryView.render(title: section.title)
                }
            }
        )
    }

    func dequeueConfiguredCell(
        collectionView: UICollectionView,
        indexPath: IndexPath,
        item: Item,
        registrations: RecommendCellRegistrations
    ) -> UICollectionViewCell {
        switch item {
        case let .countryChip(countryItem):
            collectionView.dequeueConfiguredReusableCell(
                using: registrations.countryChip,
                for: indexPath,
                item: countryItem
            )

        case let .souvenirCard(cardItem):
            collectionView.dequeueConfiguredReusableCell(
                using: registrations.souvenirCard,
                for: indexPath,
                item: cardItem
            )

        case let .moreButton(title):
            collectionView.dequeueConfiguredReusableCell(
                using: registrations.moreButton,
                for: indexPath,
                item: title
            )

        case .uploadPrompt:
            collectionView.dequeueConfiguredReusableCell(
                using: registrations.uploadPrompt,
                for: indexPath,
                item: ()
            )

        case .spacer:
            collectionView.dequeueConfiguredReusableCell(
                using: registrations.spacer,
                for: indexPath,
                item: ()
            )

        case let .empty(_, text):
            collectionView.dequeueConfiguredReusableCell(
                using: registrations.empty,
                for: indexPath,
                item: text
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

// MARK: - Layout

private extension RecommendView {
    enum Space {
        static let headerToContent: CGFloat = 12
        static let sameMeaning: CGFloat = 20
        static let differentMeaning: CGFloat = 40
        static let horizontal: CGFloat = 20

        static let cardBottom: CGFloat = 40
        static let moreBottom: CGFloat = 40
    }

    func isSectionEmpty(_ section: Section) -> Bool {
        guard let dataSource else { return false }
        let items = dataSource.snapshot().itemIdentifiers(inSection: section)
        guard items.count == 1 else { return false }
        if case .empty = items[0] { return true }
        return false
    }

    func sectionLayout(for section: Section, isEmptySection: Bool) -> NSCollectionLayoutSection {
        switch section {
        case .preferredCategoryChips:
            makeChipsSectionLayout(hasHeader: true)

        case .preferredCategoryCards:
            if isEmptySection {
                makeEmptyFullWidthSectionLayout(height: 219, hasHeader: false)
            } else {
                makeCardsSectionLayout(hasHeader: false)
            }

        case .preferredMore:
            makeMoreButtonSectionLayout()

        case .spacer:
            makeSpacerSectionLayout()

        case .uploadEmpty:
            makeUploadEmptySectionLayout(hasHeader: false)

        case .uploadBasedCards:
            makeCardsSectionLayout(hasHeader: true)

        case .uploadMore:
            makeMoreButtonSectionLayout()
        }
    }

    func makeCVLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self,
                  let section = dataSource?.sectionIdentifier(for: sectionIndex)
            else { return nil }

            let isEmptySection = isSectionEmpty(section)
            let layoutSection = sectionLayout(for: section, isEmptySection: isEmptySection)

            layoutSection.contentInsets.top = topSpacing(for: section)
            layoutSection.contentInsets.bottom = bottomSpacing(for: section)

            switch section {
            case .spacer:
                layoutSection.contentInsets.leading = 0
                layoutSection.contentInsets.trailing = 0

            default:
                layoutSection.contentInsets.leading = Space.horizontal
                layoutSection.contentInsets.trailing = Space.horizontal
            }

            return layoutSection
        }
    }

    func topSpacing(for section: Section) -> CGFloat {
        switch section {
        case .preferredCategoryChips:
            Space.headerToContent
        case .preferredCategoryCards:
            Space.sameMeaning
        case .preferredMore:
            23
        case .spacer:
            Space.differentMeaning
        case .uploadEmpty:
            0
        case .uploadBasedCards:
            Space.headerToContent
        case .uploadMore:
            23
        }
    }

    func bottomSpacing(for section: Section) -> CGFloat {
        switch section {
        case .preferredCategoryCards, .uploadBasedCards:
            Space.cardBottom
        case .preferredMore, .uploadMore:
            Space.moreBottom
        default:
            0
        }
    }

    // MARK: Sections

    func makeChipsSectionLayout(hasHeader: Bool) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(100),
            heightDimension: .absolute(40)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(100),
            heightDimension: .absolute(40)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 6

        if hasHeader {
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(27)
            )
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            section.boundarySupplementaryItems = [header]
        }

        return section
    }

    func makeCardsSectionLayout(hasHeader: Bool) -> NSCollectionLayoutSection {
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

        if hasHeader {
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
        }

        return section
    }

    func makeMoreButtonSectionLayout() -> NSCollectionLayoutSection {
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

    func makeSpacerSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(40)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(40)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        return NSCollectionLayoutSection(group: group)
    }

    func makeUploadEmptySectionLayout(hasHeader: Bool) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(240)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(240)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)

        if hasHeader {
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(80)
            )
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            section.boundarySupplementaryItems = [header]
        }

        return section
    }

    func makeEmptyFullWidthSectionLayout(height: CGFloat, hasHeader: Bool) -> NSCollectionLayoutSection {
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
}
