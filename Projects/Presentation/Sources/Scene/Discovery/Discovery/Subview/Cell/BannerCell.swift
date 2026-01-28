import AdMob
import SnapKit
import UIKit

final class BannerCell: UICollectionViewCell {
    private var bannerView: AdBannerView?
    private var isConfigured = false

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(rootViewController: UIViewController) {
        guard !isConfigured else { return }

        let banner = AdBannerView(rootViewController: rootViewController)

        contentView.addSubview(banner)
        banner.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        bannerView = banner
        banner.loadAd()

        isConfigured = true
    }
}
