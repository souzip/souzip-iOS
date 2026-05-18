import UIKit

final class MyPageCollectionTabViewController: BaseViewController<
    MyPageCollectionTabViewModel,
    MyPageCollectionTabView
> {
    func preferredBodyHeight(for layoutWidth: CGFloat) -> CGFloat {
        contentView.preferredBodyHeight(for: layoutWidth)
    }

    override func bindState() {
        observeState()
            .map { ($0.collectionData, $0.collectionSouvenirs.isEmpty) }
            .onNext(contentView.renderCollectionTab)
    }
}
