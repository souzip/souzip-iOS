import DesignSystem
import Domain
import RxSwift
import SnapKit
import UIKit

final class NoticeListView: BaseView<NoticeListAction> {
    // MARK: - Types

    typealias Section = Int
    typealias Item = Notice
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

    // MARK: - UI

    private let naviBar = DSNavigationBar(
        title: "공지사항",
        style: .back
    )

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: makeCVLayout())
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = false
        view.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        return view
    }()

    // MARK: - Data

    private var dataSource: DataSource?

    // MARK: - Override

    override func setAttributes() {
        backgroundColor = .dsBackground
        configureDataSource()
    }

    override func setHierarchy() {
        [naviBar, collectionView].forEach(addSubview)
    }

    override func setConstraints() {
        naviBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }

        collectionView.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }

    override func setBindings() {
        bind(naviBar.onLeftTap).to(.back)

        bind(collectionView.rx.itemSelected)
            .compactMap { [weak self] in self?.dataSource?.itemIdentifier(for: $0) }
            .map { .tapNotice(id: $0.id) }
    }

    // MARK: - Public

    func render(notices: [Notice]) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(notices, toSection: 0)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - Diffable / CellRegistration

private extension NoticeListView {
    func configureDataSource() {
        let registration = UICollectionView.CellRegistration<
            NoticeListCell,
            Item
        > { cell, _, item in
            cell.render(item: item)
        }

        dataSource = .init(
            collectionView: collectionView
        ) { collectionView, indexPath, item in
            collectionView.dequeueConfiguredReusableCell(
                using: registration,
                for: indexPath,
                item: item
            )
        }
    }
}

// MARK: - CollectionView Layout

private extension NoticeListView {
    func makeCVLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { _, layoutEnvironment in
            var config = UICollectionLayoutListConfiguration(appearance: .plain)
            config.showsSeparators = true
            config.separatorConfiguration.color = .dsGrey800
            config.separatorConfiguration.topSeparatorInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
            config.separatorConfiguration.bottomSeparatorInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
            config.backgroundColor = .clear
            let section = NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvironment)
            section.interGroupSpacing = 12
            return section
        }
    }
}
