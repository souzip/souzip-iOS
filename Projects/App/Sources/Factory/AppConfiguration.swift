import DesignSystem
import Logger
import Presentation
import Utils

struct AppConfiguration {
    let apiBaseURL: String = AppInfo.requiredString(.apiBaseURL)
    let kakaoAppKey: String = AppInfo.requiredString(.kakaoAppKey)
    let googleClientID: String = AppInfo.requiredString(.googleClientID)
    let amplitudeAPIKey: String = AppInfo.requiredString(.amplitudeAPIKey)

    init() {
        FontRegistration.register()
        ImageCacheConfiguration.shared.setup()
        AnalyticsManager.shared.configure(apiKey: amplitudeAPIKey)
        AnalyticsManager.shared.track(event: .appOpened)
    }
}
