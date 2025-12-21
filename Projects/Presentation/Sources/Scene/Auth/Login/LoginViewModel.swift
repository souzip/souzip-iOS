import Domain
import Logger
import RxRelay

final class LoginViewModel: BaseViewModel<
    LoginState,
    LoginAction,
    LoginEvent,
    AuthRoute
> {
    // MARK: - UseCase

    private let login: LoginUseCase

    // MARK: - Init

    init(
        login: LoginUseCase
    ) {
        self.login = login
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
            Task { await Login(provider) }
        case .tapGuest:
            break
        }
    }

    // MARK: - Private Logic

    private func Login(_ provider: AuthProvider) async {
        guard !state.value.isLoading else { return }

        do {
            let result = try await login.execute(provider: provider)
            switch result {
            case .ready: navigate(to: .main)
            case .shouldOnboarding: navigate(to: .profile)
            }
        } catch {
            emit(.errorAlert(error.localizedDescription))
        }
    }
}
