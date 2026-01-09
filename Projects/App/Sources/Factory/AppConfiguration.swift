import DesignSystem
import Presentation
import Utils

struct AppConfiguration {
    let apiBaseURL: String = AppInfo.requiredString(.apiBaseURL)
    let kakaoAppKey: String = AppInfo.requiredString(.kakaoAppKey)
    let googleClientID: String = AppInfo.requiredString(.googleClientID)

    init() {
        FontRegistration.register()
        ImageCacheConfiguration.shared.setup()
    }
}
