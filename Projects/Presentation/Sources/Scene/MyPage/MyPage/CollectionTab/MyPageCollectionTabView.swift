import DesignSystem
import SnapKit
import UIKit

final class MyPageCollectionTabView: BaseView<MyPageCollectionTabAction> {
    private let collectionView = MyCollectionView(frame: .zero)
    private let emptyView = MyPageCollectionEmptyView(frame: .zero)

    /// `render` 직후 `preferredBodyHeight`가 레이아웃 0 구간에서 호출될 때 추정치용
    private var lastSouvenirGridCount = 0

    override func setAttributes() {
        backgroundColor = .dsBackground
    }

    override func setHierarchy() {
        [
            collectionView,
            emptyView,
        ].forEach(addSubview)
    }

    override func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        emptyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override func setBindings() {
        bind(collectionView.action)
            .map { item in
                switch item {
                case let .country(countryItem):
                    .tapCountry(countryItem)
                case let .souvenir(souvenir):
                    .tapSouvenir(souvenir)
                }
            }

        bind(emptyView.action)
            .map { _ in .tapCreateSouvenir }
    }

    /// 튜플: `(collectionData, isCollectionDataEmpty)`
    func renderCollectionTab(_ input: (MyCollectionData, Bool)) {
        let (collectionData, isCollectionDataEmpty) = input
        emptyView.isHidden = !isCollectionDataEmpty
        collectionView.isHidden = isCollectionDataEmpty
        lastSouvenirGridCount = collectionData.souvenirGrid.souvenirs.count
        collectionView.render(data: collectionData)
    }

    func preferredBodyHeight(for layoutWidth: CGFloat) -> CGFloat {
        guard layoutWidth > 0 else {
            return Self.minimumReasonableBodyHeight
        }

        let widthConstraint = widthAnchor.constraint(equalToConstant: layoutWidth)
        widthConstraint.priority = UILayoutPriority(999)
        widthConstraint.isActive = true
        layoutIfNeeded()
        defer { widthConstraint.isActive = false }

        if collectionView.isHidden {
            let size = CGSize(width: layoutWidth, height: UIView.layoutFittingCompressedSize.height)
            let fitted = emptyView.systemLayoutSizeFitting(
                size,
                withHorizontalFittingPriority: .required,
                verticalFittingPriority: .fittingSizeLevel
            )
            .height
            return max(Self.minimumReasonableBodyHeight, fitted)
        }

        let measured = collectionView.displayedCollectionContentHeight()
        if measured >= 16 {
            return measured
        }

        return max(
            Self.minimumReasonableBodyHeight,
            Self.estimatedCollectionContentHeight(
                layoutWidth: layoutWidth,
                souvenirCount: lastSouvenirGridCount
            )
        )
    }
}

// MARK: - 높이 추정 (레이아웃 0·측정 실패 시 보완)

private extension MyPageCollectionTabView {
    static let minimumReasonableBodyHeight: CGFloat = 240

    static func estimatedCollectionContentHeight(layoutWidth: CGFloat, souvenirCount: Int) -> CGFloat {
        let horizontalInset: CGFloat = 20
        let interItemSpacing: CGFloat = 8
        let interGroupSpacing: CGFloat = 8
        let groupContentWidth = max(0, layoutWidth - horizontalInset * 2)
        let itemWidth = max(0, (groupContentWidth - interItemSpacing) / 2)
        let rowHeight = itemWidth

        let countryBlock: CGFloat = 16 + 30
        let gridTopInset: CGFloat = 26

        guard souvenirCount > 0 else {
            return countryBlock + gridTopInset + 80
        }

        let rows = ceil(CGFloat(souvenirCount) / 2)
        let gridBody = rows * rowHeight + max(0, rows - 1) * interGroupSpacing
        return countryBlock + gridTopInset + gridBody
    }
}
