import DesignSystem
import Domain
import RxRelay
import RxSwift
import SnapKit
import UIKit

final class SearchCountryView: BaseView<SearchCountryAction> {
    // MARK: - Types

    typealias Section = Int
    typealias Item = SearchResultItem

    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

    // MARK: - UI

    private let navigationBar = DSNavigationBar(
        title: "검색",
        style: .back
    )

    private let searchTextFieldView = SearchTextFieldView()

    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.keyboardDismissMode = .onDrag
        collectionView.delegate = self
        return collectionView
    }()

    private let emptyView = SearchEmptyView()

    // MARK: - Data

    private var dataSource: DataSource?
    private var currentSearchText: String = ""

    // MARK: - Override

    override func setAttributes() {
        backgroundColor = .dsBackground
        hideKeyboardWhenTappedAround()
        configureDataSource()
    }

    override func setHierarchy() {
        [
            navigationBar,
            searchTextFieldView,
            collectionView,
            emptyView,
        ].forEach { addSubview($0) }
    }

    override func setConstraints() {
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }

        searchTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(20)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchTextFieldView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        emptyView.snp.makeConstraints { make in
            make.edges.equalTo(collectionView)
        }
    }

    override func setBindings() {
        bind(navigationBar.onLeftTap).to(.back)

        bind(searchTextFieldView.textChanged.asObservable())
            .map { .searchTextChangedUI($0) }

        bind(searchTextFieldView.textChanged.asObservable())
            .debounce(.seconds(2))
            .map { .searchTextChangedAPI($0) }

        bind(searchTextFieldView.clearButtonTapped.asObservable())
            .to(.clearSearch)
    }

    // MARK: - Public

    func render(items: [SearchResultItem], searchText: String) {
        currentSearchText = searchText

        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(items, toSection: 0)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }

    func render(isEmpty: Bool) {
        emptyView.isHidden = !isEmpty
        collectionView.isHidden = isEmpty
    }

    func focusSearchField() {
        searchTextFieldView.textField.becomeFirstResponder()
    }

    // MARK: - Private

    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(70)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(70)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 13
        section.contentInsets = .init(top: 10, leading: 20, bottom: 20, trailing: 20)

        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: - Diffable / CellRegistration

private extension SearchCountryView {
    func configureDataSource() {
        let registration = UICollectionView.CellRegistration<
            SearchResultCell,
            Item
        > { [weak self] cell, _, item in
            guard let self else { return }
            cell.render(item: item, searchText: currentSearchText)
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

// MARK: - UICollectionView Delegate

extension SearchCountryView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource?.itemIdentifier(for: indexPath) else { return }
        action.accept(.selectItem(item))
    }
}
