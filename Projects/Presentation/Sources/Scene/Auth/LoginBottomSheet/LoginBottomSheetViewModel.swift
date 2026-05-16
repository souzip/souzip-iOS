import Domain
import RxRelay

final class LoginBottomSheetViewModel: BaseViewModel<
    LoginBottomSheetState,
    LoginBottomSheetAction,
    LoginBottomSheetEvent,
    LoginBottomSheetRoute
> {
    // MARK: - UseCase

    private let login: LoginUseCase
    private let authSessionStore: AuthSessionStore

    // MARK: - Init

    init(login: LoginUseCase, authSessionStore: AuthSessionStore) {
        self.login = login
        self.authSessionStore = authSessionStore
        super.init(initialState: State())
    }

    // MARK: - Action Handling

    override func handleAction(_ action: Action) {
        switch action {
        case let .tapLogin(provider):
            Task {
                emit(.loading(true))
                await performLogin(provider)
                emit(.loading(false))
            }

        case .close:
            emit(.dismiss)
        }
    }

    // MARK: - Private

    private func performLogin(_ provider: AuthProvider) async {
        do {
            let result = try await login.execute(provider: provider)
            switch result {
            case .ready:
                await authSessionStore.refreshSession()
                emit(.dismiss)
                navigate(to: .complete)

            case .shouldOnboarding:
                await authSessionStore.refreshSession()
                emit(.dismiss)
                navigate(to: .terms)

            default:
                break
            }
        } catch {
            emit(.errorAlert(error.localizedDescription))
        }
    }
}
