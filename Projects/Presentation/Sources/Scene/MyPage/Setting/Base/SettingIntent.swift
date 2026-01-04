import Foundation

enum SettingAction {
    case back
    case tapItem(SettingItemType)
    case logout
    case withdraw
}

struct SettingState {}

enum SettingEvent {
    case showLogoutAlert
    case showWithdrawAlert
    case showSFView(URL)
}
