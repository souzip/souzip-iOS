import Domain

enum LoginAction {
    case tapLogin(AuthProvider)
    case tapGuest
}

struct LoginState {
    var isLoading: Bool = false
    var recentAuthProvider: AuthProvider? = .apple
}

enum LoginEvent {
    case loading(Bool)
    case errorAlert(String)
}
