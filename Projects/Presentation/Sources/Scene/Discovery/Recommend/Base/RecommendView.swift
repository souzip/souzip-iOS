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
        view.delegate = self
        view.refreshControl = refreshContorl
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

private extension RecommendView {
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

        let moreButtonRegistration = UICollectionView.CellRegistration<
            MoreButtonCell,
            String
        > { cell, _, title in
            cell.render(title: title)
        }

        let uploadPromptRegistration = UICollectionView.CellRegistration<
            UploadPromptCell,
            Void
        > { cell, _, _ in
            cell.action
                .bind { [weak self] in
                    self?.action.accept(.uploadButtonTap)
                }
                .disposed(by: cell.disposeBag)
        }

        let spacerRegistration = UICollectionView.CellRegistration<
            UICollectionViewCell,
            Void
        > { _, _, _ in }

        let emptyRegistration = UICollectionView.CellRegistration<
            EmptyStateCell,
            String
        > { cell, _, text in
            cell.render(text)
        }

        let headerRegistration = UICollectionView.SupplementaryRegistration<
            RecommendSectionHeaderView
        >(
            elementKind: UICollectionView.elementKindSectionHeader
        ) { [weak self] supplementaryView, _, indexPath in
            guard let self,
                  let section = dataSource?.sectionIdentifier(for: indexPath.section)
            else { return }

            // 헤더 없는 섹션은 여기서 early return
            switch section {
            case .preferredMore, .uploadMore, .uploadEmpty, .spacer:
                supplementaryView.isHidden = true
                supplementaryView.render(title: "")
                return
            default:
                supplementaryView.isHidden = false
                supplementaryView.render(title: section.title)
            }
        }

        dataSource = .init(
            collectionView: collectionView
        ) { collectionView, indexPath, item in
            switch item {
            case let .countryChip(countryItem):
                collectionView.dequeueConfiguredReusableCell(
                    using: countryChipRegistration,
                    for: indexPath,
                    item: countryItem
                )

            case let .souvenirCard(cardItem):
                collectionView.dequeueConfiguredReusableCell(
                    using: souvenirCardRegistration,
                    for: indexPath,
                    item: cardItem
                )

            case let .moreButton(title):
                collectionView.dequeueConfiguredReusableCell(
                    using: moreButtonRegistration,
                    for: indexPath,
                    item: title
                )

            case .uploadPrompt:
                collectionView.dequeueConfiguredReusableCell(
                    using: uploadPromptRegistration,
                    for: indexPath,
                    item: ()
                )

            case .spacer:
                collectionView.dequeueConfiguredReusableCell(
                    using: spacerRegistration,
                    for: indexPath,
                    item: ()
                )

            case let .empty(_, text):
                collectionView.dequeueConfiguredReusableCell(
                    using: emptyRegistration,
                    for: indexPath,
                    item: text
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

    func makeCVLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self,
                  let section = dataSource?.sectionIdentifier(for: sectionIndex)
            else { return nil }

            let isEmptySection: Bool = {
                guard let ds = self.dataSource else { return false }
                let snapshot = ds.snapshot()
                let items = snapshot.itemIdentifiers(inSection: section)
                guard items.count == 1 else { return false }
                if case .empty = items[0] { return true }
                return false
            }()

            let layoutSection: NSCollectionLayoutSection = switch section {
            case .preferredCategoryChips:
                makeChipsSectionLayout(hasHeader: true)

            case .preferredCategoryCards:
                isEmptySection
                    ? makeEmptyFullWidthSectionLayout(height: 219, hasHeader: false)
                    : makeCardsSectionLayout(hasHeader: false)

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

            // insets
            layoutSection.contentInsets.top = topSpacing(for: section)
            layoutSection.contentInsets.bottom = bottomSpacing(for: section)

            // horizontal insets: spacer는 전체폭, 나머지는 20
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

        let section = NSCollectionLayoutSection(group: group)

        return section
    }
}

// MARK: - UICollectionView Delegate

extension RecommendView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource?.itemIdentifier(for: indexPath) else { return }

        switch item {
        case let .countryChip(countryItem):
            action.accept(.countryChipTap(.init(
                countryCode: countryItem.countryCode,
                title: countryItem.title,
                flagImage: countryItem.flagImage,
                isSelected: countryItem.isSelected
            )))

        case let .souvenirCard(cardItem):
            action.accept(.souvenirCardTap(cardItem))

        case .uploadPrompt:
            action.accept(.uploadButtonTap)

        case .moreButton:
            guard let section = dataSource?.sectionIdentifier(for: indexPath.section) else { return }
            switch section {
            case .preferredMore:
                action.accept(.preferredMoreTap)
            case .uploadMore:
                action.accept(.uploadMoreTap)
            default:
                break
            }

        default:
            break
        }
    }
}
