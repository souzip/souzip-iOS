import DesignSystem
import Domain
import RxCocoa
import SnapKit
import UIKit

final class TermsView: BaseView<TermsAction> {
    // MARK: - Constants

    private typealias Metric = TermsConstants
    private typealias Strings = TermsConstants.Strings

    // MARK: - Types

    private enum Section: Int, CaseIterable {
        case allAgree
        case terms
    }

    private enum Item: Hashable {
        case allAgree(isAgreed: Bool)
        case term(TermsItem)
    }

    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

    // MARK: - Properties

    private var dataSource: DataSource?

    // MARK: - UI

    private let naviBar = DSNavigationBar(
        title: Strings.navigationTitle,
        style: .back
    )

    private let titleLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.text = Strings.title
        label.textColor = .dsGreyWhite
        label.numberOfLines = 0
        label.setTypography(.subhead24SB)
        return label
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createCVLayout()
        )
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.delaysContentTouches = false
        collectionView.delegate = self
        return collectionView
    }()

    private let agreeButton: DSButton = {
        let button = DSButton()
        button.setTitle(Strings.agreeButton)
        button.setEnabled(false)
        return button
    }()

    // MARK: - Lifecycle

    override func setAttributes() {
        backgroundColor = .dsBackground
        configureDataSource()
    }

    override func setHierarchy() {
        [
            naviBar,
            titleLabel,
            collectionView,
            agreeButton,
        ].forEach(addSubview)
    }

    override func setConstraints() {
        naviBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(Metric.naviBarTopOffset)
            make.horizontalEdges.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom).offset(Metric.titleTopOffset)
            make.horizontalEdges.equalToSuperview().inset(Metric.titleHorizontalInset)
            make.height.equalTo(Metric.titleHeight)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Metric.collectionViewTopOffset)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(agreeButton.snp.top).offset(Metric.collectionViewBottomOffset)
        }

        agreeButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Metric.agreeButtonHorizontalInset)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(Metric.agreeButtonBottomInset)
            make.height.equalTo(Metric.agreeButtonHeight)
        }
    }

    override func setBindings() {
        bind(naviBar.onLeftTap).to(.tapback)
        bind(agreeButton.rx.tap).to(.tapAgreeButton)
    }

    // MARK: - Render

    func renderItems(_ items: [TermsItem]) {
        let isAllAgreed = items.isAllAgreed
        applySnapshot(items: items, isAllAgreed: isAllAgreed)
    }

    func renderAgreeButtonEnabled(_ isEnabled: Bool) {
        agreeButton.setEnabled(isEnabled)
    }

    // MARK: - Private

    private func createCVLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self,
                  let sectionKind = dataSource?.sectionIdentifier(for: sectionIndex)
            else { return nil }

            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(Metric.itemHeight)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(Metric.itemHeight)
            )
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: groupSize,
                subitems: [item]
            )

            let section = NSCollectionLayoutSection(group: group)

            let topInset: CGFloat = (sectionKind == .terms) ? Metric.termsTopInset : 0

            section.contentInsets = .init(
                top: topInset,
                leading: Metric.horizontalInset,
                bottom: 0,
                trailing: Metric.horizontalInset
            )
            section.interGroupSpacing = 0

            return section
        }
    }

    private func configureDataSource() {
        let allAgreeCellRegistration = UICollectionView.CellRegistration<
            TermsAllAgreeCell,
            Bool
        > { cell, _, isAgreed in
            cell.render(isAgreed)
        }

        let termCellRegistration = UICollectionView.CellRegistration<
            TermsCell,
            TermsItem
        > { [weak self] cell, _, item in
            guard let self else { return }

            cell.render(item)
            cell.action
                .bind { [weak self] action in
                    switch action {
                    case .tapDetail:
                        self?.action.accept(.tapTermDetail(item.type))
                    }
                }
                .disposed(by: cell.disposeBag)
        }

        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            switch item {
            case let .allAgree(isAgreed):
                collectionView.dequeueConfiguredReusableCell(
                    using: allAgreeCellRegistration,
                    for: indexPath,
                    item: isAgreed
                )

            case let .term(termsItem):
                collectionView.dequeueConfiguredReusableCell(
                    using: termCellRegistration,
                    for: indexPath,
                    item: termsItem
                )
            }
        }
    }

    private func applySnapshot(items: [TermsItem], isAllAgreed: Bool) {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)

        snapshot.appendItems([.allAgree(isAgreed: isAllAgreed)], toSection: .allAgree)
        snapshot.appendItems(items.map { .term($0) }, toSection: .terms)

        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}

extension TermsView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource?.itemIdentifier(for: indexPath) else { return }

        let action: TermsAction = switch item {
        case .allAgree:
            .tapAllAgree
        case let .term(termsItem):
            .tapTerm(termsItem.type)
        }

        self.action.accept(action)
    }
}
