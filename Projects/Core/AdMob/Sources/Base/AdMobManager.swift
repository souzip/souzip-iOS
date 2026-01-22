import AdSupport
import AppTrackingTransparency
import GoogleMobileAds

public final class AdMobManager {
    public static let shared = AdMobManager()

    private init() {}

    @MainActor
    public func initialize() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            ATTrackingManager.requestTrackingAuthorization { _ in
                MobileAds.shared.start(completionHandler: nil)
            }
        }
    }
}
