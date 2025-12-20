import Foundation
import Utils

struct AppConfiguration {
    let apiBaseURL: String = AppInfo.requiredString(.apiBaseURL)
    let kakaoAppKey: String = AppInfo.requiredString(.kakaoAppKey)
    let googleClientID: String = AppInfo.requiredString(.googleClientID)
    let appleServiceID: String = AppInfo.requiredString(.appleServiceID)
}
