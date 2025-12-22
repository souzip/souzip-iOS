import DesignSystem
import Domain
import RxCocoa
import SnapKit
import UIKit

final class TermsView: BaseView<TermsAction> {
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
        title: "이용약관",
        style: .back
    )

    private let titleLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.text = "이용약관 동의가 필요해요"
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
        button.setTitle("동의하기")
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
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(36)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(46)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(agreeButton.snp.top).offset(-12)
        }

        agreeButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
    }

    override func setBindings() {
        bind(naviBar.onLeftTap).to(.tapback)
        bind(agreeButton.rx.tap).to(.tapAgreeButton)
    }

    // MARK: - Public

    func render(items: [TermsItem]) {
        let isAllAgreed = items.isAllAgreed
        applySnapshot(items: items, isAllAgreed: isAllAgreed)
    }

    func render(isEnabled: Bool) {
        agreeButton.setEnabled(isEnabled)
    }

    // MARK: - Private

    private func createCVLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }

            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(48)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(48)
            )
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: groupSize,
                subitems: [item]
            )

            let section = NSCollectionLayoutSection(group: group)

            let topInset: CGFloat = (sectionKind == .terms) ? 8 : 0

            section.contentInsets = .init(
                top: topInset,
                leading: 20,
                bottom: 0,
                trailing: 20
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
