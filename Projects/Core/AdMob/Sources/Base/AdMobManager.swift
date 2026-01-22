import GoogleMobileAds

public final class AdMobManager {
    public static let shared = AdMobManager()

    private init() {}

    public func initialize() {
        MobileAds.shared.start(completionHandler: nil)
    }
}
