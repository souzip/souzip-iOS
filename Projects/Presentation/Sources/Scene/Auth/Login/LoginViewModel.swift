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

    // MARK: - Override

    override func bindState() {
        observe(\.isLoading)
            .skip(1)
            .map { .loading($0) }
            .onNext(emit)
    }

    // MARK: - Action Handling

    override func handleAction(_ action: Action) {
        switch action {
        case .viewWillAppear:
            Task { await loadRecentProvider() }
        case let .tapLogin(provider):
            Task { await Login(provider) }
        case .tapGuest:
            navigate(to: .main)
        }
    }

    // MARK: - Private Logic

    private func loadRecentProvider() async {
        let provider = await loadRecentAuthProvider.execute()
        mutate { $0.recentAuthProvider = provider }
    }

    private func Login(_ provider: AuthProvider) async {
        guard !state.value.isLoading else { return }

        mutate { $0.isLoading = true }
        defer { mutate { $0.isLoading = false } }

        do {
            let result = try await login.execute(provider: provider)
            switch result {
            case .ready: navigate(to: .main)
            case .shouldOnboarding: navigate(to: .terms)
            }
        } catch {
            emit(.errorAlert(error.localizedDescription))
        }
    }
}
