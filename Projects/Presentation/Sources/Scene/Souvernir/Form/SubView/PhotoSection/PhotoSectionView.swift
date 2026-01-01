import DesignSystem
import Domain
import Kingfisher
import Photos
import RxCocoa
import RxSwift
import SnapKit
import UIKit

enum PhotoSectionAction {
    case tapAdd
    case tapRemoveLocal(UUID)
}

final class PhotoSectionView: UIView {
    // MARK: - Types

    typealias Section = Int

    enum Item: Hashable {
        case addButton(Int)
        case local(LocalPhoto)
        case remote(SouvenirFile)
    }

    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

    // MARK: - Properties

    let action = PublishRelay<PhotoSectionAction>()
    private let disposeBag = DisposeBag()

    private var mainPhotoIndex: Int?

    // MARK: - UI

    private let titleLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.text = "사진 첨부"
        label.textColor = .dsGreyWhite
        label.setTypography(.body1SB)
        return label
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createLayout()
        )
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        return collectionView
    }()

    // MARK: - Data

    private var dataSource: DataSource?

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public

    func renderCreate(localPhotos: [LocalPhoto]) {
        var items: [Item] = []

        // add 버튼: 5개 미만일 때만
        if localPhotos.count < 5 {
            items.append(.addButton(localPhotos.count))
        }

        // 사진들
        items.append(contentsOf: localPhotos.map { .local($0) })

        mainPhotoIndex = items.firstIndex { item in
            if case .local = item { return true }
            return false
        }

        applySnapshot(items)
    }

    func renderEdit(existingFiles: [SouvenirFile]) {
        let sorted = existingFiles.sorted { $0.displayOrder < $1.displayOrder }
        let items: [Item] = sorted.map { .remote($0) }

        mainPhotoIndex = items.firstIndex { item in
            if case .remote = item { return true }
            return false
        }

        applySnapshot(items)
    }

    private func applySnapshot(_ items: [Item]) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(items, toSection: 0)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }

    // MARK: - Private

    private func configure() {
        setHierarchy()
        setConstraints()
        configureDataSource()
    }

    private func setHierarchy() {
        [titleLabel, collectionView].forEach { addSubview($0) }
    }

    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(84)
            make.bottom.equalToSuperview()
        }
    }

    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(84),
            heightDimension: .absolute(84)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(84),
            heightDimension: .absolute(84)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)

        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: - Diffable / CellRegistration

private extension PhotoSectionView {
    func configureDataSource() {
        let addButtonRegistration = UICollectionView.CellRegistration<AddPhotoCell, Item> { cell, _, item in
            guard case let .addButton(count) = item else { return }
            cell.render(currentCount: count)
        }

        let photoRegistration = UICollectionView.CellRegistration<PhotoCell, Item> { [weak self] cell, indexPath, item in
            guard let self else { return }

            let isMain = (indexPath.item == mainPhotoIndex)

            switch item {
            case let .local(photo):
                cell.renderLocal(url: photo.url, isMain: isMain, showDelete: true)
                cell.onTapDelete = { [weak self] in
                    self?.action.accept(.tapRemoveLocal(photo.id))
                }

            case let .remote(file):
                cell.renderRemote(file: file, isMain: isMain, showDelete: false)
                cell.onTapDelete = nil

            case .addButton:
                break
            }
        }

        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            switch item {
            case .addButton:
                collectionView.dequeueConfiguredReusableCell(
                    using: addButtonRegistration,
                    for: indexPath,
                    item: item
                )
            case .local, .remote:
                collectionView.dequeueConfiguredReusableCell(
                    using: photoRegistration,
                    for: indexPath,
                    item: item
                )
            }
        }
    }
}

// MARK: - UICollectionViewDelegate

extension PhotoSectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource?.itemIdentifier(for: indexPath) else { return }

        if case .addButton = item {
            action.accept(.tapAdd)
        }
    }
}
