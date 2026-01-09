import Domain

final class SplashViewModel: BaseViewModel<
    SplashState,
    SplashAction,
    SplashEvent,
    AuthRoute
> {
    // MARK: - UseCase

    private let autoLogin: AutoLoginUseCase

    // MARK: - Init

    init(autoLogin: AutoLoginUseCase) {
        self.autoLogin = autoLogin
        super.init(initialState: State(minDisplayTime: .seconds(3)))
        Task { await checkStatus() }
    }

    // MARK: - Private Logic

    private func checkStatus() async {
        async let loginTask = autoLogin.execute()
        async let delay: Void = Task.sleep(for: state.value.minDisplayTime)

        let result = await loginTask
        try? await delay

        switch result {
        case .ready: navigate(to: .main)
        case .shouldLogin: navigate(to: .login)
        case .shouldOnboarding: navigate(to: .terms)
        }
    }
}
