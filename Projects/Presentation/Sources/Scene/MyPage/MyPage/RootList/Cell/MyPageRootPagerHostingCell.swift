import DesignSystem
import SnapKit
import UIKit

final class MyPageRootPagerHostingCell: UICollectionViewCell {
    /// `MyPageViewController`가 Parchment 뷰를 붙이는 컨테이너
    let hostContainerView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        backgroundColor = .dsBackground
        contentView.backgroundColor = .dsBackground

        contentView.addSubview(hostContainerView)
        hostContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
