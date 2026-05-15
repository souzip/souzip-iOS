import Ads
import Domain

final class SplashViewModel: BaseViewModel<
    SplashState,
    SplashAction,
    SplashEvent,
    AuthRoute
> {
    // MARK: - UseCase

    private let autoLogin: AutoLoginUseCase
    private let authSessionStore: AuthSessionStore

    // MARK: - Init

    init(autoLogin: AutoLoginUseCase, authSessionStore: AuthSessionStore) {
        self.autoLogin = autoLogin
        self.authSessionStore = authSessionStore
        super.init(initialState: State(minDisplayTime: .seconds(3)))
        Task { await checkStatus() }
    }

    // MARK: - Private Logic

    private func checkStatus() async {
        await AdMobManager.shared.initialize()

        async let loginTask = autoLogin.execute()
        async let delay: Void = Task.sleep(for: state.value.minDisplayTime)

        let result = await loginTask
        try? await delay

        switch result {
        case .ready:
            await authSessionStore.refreshSession()
            navigate(to: .main)
        case .shouldLogin:
            navigate(to: .login)
        case .shouldOnboarding:
            await authSessionStore.refreshSession()
            navigate(to: .terms)
        }
    }
}
