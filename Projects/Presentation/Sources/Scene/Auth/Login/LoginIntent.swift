import Domain

enum LoginAction {
    case viewWillAppear
    case tapLogin(AuthProvider)
    case tapGuest
}

struct LoginState {
    var isLoading: Bool = false
    var recentAuthProvider: AuthProvider?
}

enum LoginEvent {
    case loading(Bool)
    case errorAlert(String)
}
