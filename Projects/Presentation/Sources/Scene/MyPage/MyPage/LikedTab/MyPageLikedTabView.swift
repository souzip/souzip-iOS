import DesignSystem
import SnapKit
import UIKit

final class MyPageLikedTabView: BaseView<MyPageLikedTabAction> {
    private let emptyView = MyPageLikedEmptyView(frame: .zero)

    override func setAttributes() {
        backgroundColor = .dsBackground
    }

    override func setHierarchy() {
        addSubview(emptyView)
    }

    override func setConstraints() {
        emptyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override func setBindings() {}

    func preferredBodyHeight(for layoutWidth: CGFloat) -> CGFloat {
        guard layoutWidth > 0 else { return 240 }

        let widthConstraint = widthAnchor.constraint(equalToConstant: layoutWidth)
        widthConstraint.priority = UILayoutPriority(999)
        widthConstraint.isActive = true
        layoutIfNeeded()
        defer { widthConstraint.isActive = false }

        let size = CGSize(width: layoutWidth, height: UIView.layoutFittingCompressedSize.height)
        let fitted = emptyView.systemLayoutSizeFitting(
            size,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        .height
        return max(240, fitted)
    }
}
