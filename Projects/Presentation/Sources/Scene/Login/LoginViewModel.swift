import Domain
import Logger
import RxRelay

final class LoginViewModel: BaseViewModel<
    LoginState,
    LoginAction,
    LoginEvent,
    AuthRoute
> {
    // MARK: - Init

    init() {
        super.init(initialState: State())
        bindState()
    }

    // MARK: - Override

    override func bindState() {
        observe(\.isLoading) { self.emit(.loading($0)) }
    }

    // MARK: - Action Handling

    override func handleAction(_ action: Action) {
        switch action {
        case let .tapLogin(provider):
            Login(provider)
        case .tapGuest:
            break
        }
    }

    // MARK: - Private Logic

    private func Login(_ provider: AuthProvider) {
        guard !state.value.isLoading else { return }
        print(provider)
    }
}
