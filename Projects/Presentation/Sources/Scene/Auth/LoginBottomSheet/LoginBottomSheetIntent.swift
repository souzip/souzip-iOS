import Domain

struct LoginBottomSheetState {
    var isLoading: Bool = false
}

enum LoginBottomSheetAction {
    case tapLogin(AuthProvider)
    case close
}

enum LoginBottomSheetEvent {
    case loading(Bool)
    case errorAlert(String)
    case dismiss
}
