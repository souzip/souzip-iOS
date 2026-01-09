import DesignSystem
import Domain
import RxRelay
import RxSwift
import SnapKit
import UIKit

final class SouvenirGridView: UIView {
    // MARK: - Action

    let itemTap = PublishRelay<Item>()
    let shouldDismissSheet = PublishRelay<Void>()
    let tapUpload = PublishRelay<Void>()

    private let disposeBag = DisposeBag()

    // MARK: - Types

    typealias Section = Int
    typealias Item = SouvenirListItem // 기념품 모델

    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

    // MARK: - UI

    private let titleLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.text = "근처에 있는 기념품이에요"
        label.textColor = .dsGreyWhite
        label.setTypography(.body1SB)
        return label
    }()

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: makeCVLayout())
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = true
        view.bounces = false
        view.delegate = self
        return view
    }()

    private let emptyView = SouvenirEmptyView()

    // MARK: - Data

    private var dataSource: DataSource?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Public

    func render(items: [Item]) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(items, toSection: 0)
        dataSource?.apply(snapshot, animatingDifferences: false)

        updateEmptyState(isEmpty: items.isEmpty)
    }

    private func updateEmptyState(isEmpty: Bool) {
        titleLabel.isHidden = isEmpty
        collectionView.isHidden = isEmpty
        emptyView.isHidden = !isEmpty
    }
}

// MARK: - UI Configuration

private extension SouvenirGridView {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
        setBindings()
    }

    func setAttributes() {
        backgroundColor = .clear
        configureDataSource()
    }

    func setHierarchy() {
        [
            titleLabel,
            collectionView,
            emptyView,
        ].forEach(addSubview)
    }

    func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(27)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        emptyView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(55)
            make.centerX.equalToSuperview()
        }
    }

    func setBindings() {
        emptyView.tapUpload
            .bind(to: tapUpload)
            .disposed(by: disposeBag)
    }
}

// MARK: - Diffable / CellRegistration

private extension SouvenirGridView {
    func configureDataSource() {
        let registration = UICollectionView.CellRegistration<
            SouvenirGridCell,
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

private extension SouvenirGridView {
    func makeCVLayout() -> UICollectionViewLayout {
        let horizontalInset: CGFloat = 20
        let interItemSpacing: CGFloat = 7
        let lineSpacing: CGFloat = 7

        // 셀 너비 계산: (전체너비 - 좌여백 - 우여백 - 가로간격) / 2
        let totalWidth = UIScreen.main.bounds.width
        let availableWidth = totalWidth - (horizontalInset * 2) - interItemSpacing
        let itemWidth = availableWidth / 2

        // 셀 높이 계산: 164:219 비율
        let itemHeight = itemWidth * (219.0 / 164.0)

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(itemWidth),
            heightDimension: .absolute(itemHeight)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(itemHeight)
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.interItemSpacing = .fixed(interItemSpacing)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = lineSpacing
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: horizontalInset,
            bottom: horizontalInset,
            trailing: horizontalInset
        )

        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: - UICollectionView Delegate

extension SouvenirGridView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource?.itemIdentifier(for: indexPath) else { return }
        itemTap.accept(item)
        collectionView.deselectItem(at: indexPath, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY < 0 {
            shouldDismissSheet.accept(())
        }
    }
}
