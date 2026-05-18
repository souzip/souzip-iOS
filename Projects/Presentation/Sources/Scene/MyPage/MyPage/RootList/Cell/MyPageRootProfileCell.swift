import DesignSystem
import SnapKit
import UIKit

final class MyPageRootProfileCell: UICollectionViewCell {
    private let headerView = MyPageHeaderView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func render(_ profile: ProfileData) {
        headerView.render(profile)
    }

    private func configure() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        contentView.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
    }
}
