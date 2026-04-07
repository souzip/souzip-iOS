import DesignSystem
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
        return collectionView
    }()

    private let onboardingView = SearchCountryOnboardingView()
    private let noResultsView = SearchCountryNoResultsView()

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
            noResultsView,
            onboardingView,
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

        noResultsView.snp.makeConstraints { make in
            make.top.equalTo(searchTextFieldView.snp.bottom).offset(125)
            make.centerX.equalToSuperview()
        }

        onboardingView.snp.makeConstraints { make in
            make.top.equalTo(searchTextFieldView.snp.bottom).offset(70)
            make.centerX.equalToSuperview()
        }
    }

    override func setBindings() {
        bind(navigationBar.onLeftTap).to(.back)

        bind(searchTextFieldView.textChanged.asObservable())
            .map { .searchTextChangedUI($0) }

        bind(searchTextFieldView.textChanged.asObservable())
            .debounce(.milliseconds(500))
            .map { .searchTextChangedAPI($0) }

        bind(searchTextFieldView.clearButtonTapped.asObservable())
            .to(.clearSearch)

        bind(searchTextFieldView.returnKeyTapped.asObservable())
            .to(.returnKeyTapped)

        bind(collectionView.rx.itemSelected)
            .compactMap { [weak self] in self?.dataSource?.itemIdentifier(for: $0) }
            .map { .selectItem($0) }
    }

    // MARK: - Public

    func render(items: [SearchResultItem], searchText: String) {
        currentSearchText = searchText

        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(items, toSection: 0)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }

    func render(mainPane: SearchCountryMainPane) {
        onboardingView.isHidden = mainPane != .onboarding
        noResultsView.isHidden = mainPane != .noResults
        collectionView.isHidden = mainPane != .results
    }

    func focusSearchField() {
        searchTextFieldView.focus()
    }

    func setInitialSearchText(_ text: String) {
        searchTextFieldView.setText(text)
    }

    func render(mode: SearchCountryMode) {
        switch mode {
        case .country:
            searchTextFieldView.setPlaceholder("어디로 떠나시나요?")
        case .store:
            searchTextFieldView.setPlaceholder("어디에서 구매하셨나요?")
        }
        onboardingView.render(mode: mode)
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
        let cityRegistration = UICollectionView.CellRegistration<
            CitySearchResultCell,
            Item
        > { [weak self] cell, _, item in
            guard let self else { return }
            cell.render(item: item, searchText: currentSearchText)
        }

        let placeRegistration = UICollectionView.CellRegistration<
            PlaceSearchResultCell,
            Item
        > { [weak self] cell, _, item in
            guard let self else { return }
            cell.render(item: item, searchText: currentSearchText)
        }

        dataSource = .init(
            collectionView: collectionView
        ) { collectionView, indexPath, item in
            switch item.detail {
            case .city:
                collectionView.dequeueConfiguredReusableCell(
                    using: cityRegistration,
                    for: indexPath,
                    item: item
                )

            case .place:
                collectionView.dequeueConfiguredReusableCell(
                    using: placeRegistration,
                    for: indexPath,
                    item: item
                )
            }
        }
    }
}
