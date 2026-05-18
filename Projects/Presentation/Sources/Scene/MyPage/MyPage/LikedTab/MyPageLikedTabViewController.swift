import UIKit

final class MyPageLikedTabViewController: BaseViewController<
    MyPageLikedTabViewModel,
    MyPageLikedTabView
> {
    func preferredBodyHeight(for layoutWidth: CGFloat) -> CGFloat {
        contentView.preferredBodyHeight(for: layoutWidth)
    }
}
