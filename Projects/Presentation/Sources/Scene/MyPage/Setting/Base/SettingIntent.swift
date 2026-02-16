import Foundation

enum SettingAction {
    case viewDidLoad
    case back
    case tapItem(SettingItemType)
    case logout
    case withdraw
}

struct SettingState {
    var isGuest: Bool = true
    var sections: [SettingSection] {
        var sections: [SettingSection] = [
            .terms,
            .general,
            .support,
        ]

        if !isGuest {
            sections.append(.etc)
        }

        return sections
    }
}

enum SettingEvent {
    case showLogoutAlert
    case showWithdrawAlert
    case showSFView(URL)
}
