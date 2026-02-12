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

    private let loadRecentAuthProvider: LoadRecentAuthProviderUseCase
    private let login: LoginUseCase

    // MARK: - Init

    init(
        loadRecentAuthProvider: LoadRecentAuthProviderUseCase,
        login: LoginUseCase
    ) {
        self.loadRecentAuthProvider = loadRecentAuthProvider
        self.login = login
        super.init(initialState: State())
        bindState()
    }

    // MARK: - Action Handling

    override func handleAction(_ action: Action) {
        switch action {
        case .viewWillAppear:
            Task { await loadRecentProvider() }

        case let .tapLogin(provider):
            Task {
                emit(.loading(true))
                await Login(provider)
                emit(.loading(false))
            }

        case .tapGuest:
            Task { await Login(nil) }
        }
    }

    // MARK: - Private Logic

    private func loadRecentProvider() async {
        let provider = await loadRecentAuthProvider.execute()
        mutate { $0.recentAuthProvider = provider }
    }

    private func Login(_ provider: AuthProvider?) async {
        do {
            let result = try await login.execute(provider: provider)
            switch result {
            case .ready, .guest:
                navigate(to: .main)
            case .shouldOnboarding:
                navigate(to: .terms)
            }
        } catch {
            emit(.errorAlert(error.localizedDescription))
        }
    }
}
