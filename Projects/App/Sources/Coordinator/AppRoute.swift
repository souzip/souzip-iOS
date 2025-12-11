enum AppRoute: CustomStringConvertible {
    case splash
    case auth
    case main

    var description: String {
        switch self {
        case .splash: "Splash 화면 이동"
        case .auth: "Auth 화면 이동"
        case .main: "Main 화면 이동"
        }
    }
}
