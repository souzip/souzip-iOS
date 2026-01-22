import GoogleMobileAds
import Logger
import UIKit
import Utils

public final class AdBannerView: UIView {
    // MARK: - Properties

    private let bannerView: BannerView

    // MARK: - Initializer

    public init(rootViewController: UIViewController) {
        bannerView = BannerView(adSize: AdSizeBanner)

        super.init(frame: .zero)

        bannerView.adUnitID = AppInfo.requiredString(.bannerUnitID)

        bannerView.rootViewController = rootViewController
        bannerView.delegate = self
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupLayout() {
        addSubview(bannerView)
        bannerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            bannerView.topAnchor.constraint(equalTo: topAnchor),
            bannerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bannerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bannerView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    // MARK: - Public Methods

    public func loadAd() {
        let request = Request()
        bannerView.load(request)
    }
}

extension AdBannerView: BannerViewDelegate {
    public func bannerViewDidRecordClick(_ bannerView: BannerView) {
        AnalyticsManager.shared.track(event: .tapBanner)
    }
}
