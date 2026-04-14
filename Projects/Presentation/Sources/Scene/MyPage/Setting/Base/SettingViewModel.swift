import Domain
import Foundation

final class SettingViewModel: BaseViewModel<
    SettingState,
    SettingAction,
    SettingEvent,
    MyPageRoute
> {
    // MARK: - UseCase

    private let checkFullAuthentication: CheckFullAuthenticationUseCase
    private let logout: LogoutUseCase

    // MARK: - Init

    init(
        checkFullAuthentication: CheckFullAuthenticationUseCase,
        logout: LogoutUseCase
    ) {
        self.checkFullAuthentication = checkFullAuthentication
        self.logout = logout
        super.init(initialState: State())
    }

    // MARK: - Action Handling

    override func handleAction(_ action: Action) {
        switch action {
        case .viewDidLoad:
            Task { await handleViewDidLoad() }

        case .back:
            navigate(to: .pop)

        case let .tapItem(type):
            handleType(type)

        case .logout:
            Task {
                try? await logout.execute()
                navigate(to: .login)
            }
        }
    }

    // MARK: - Private Logic

    private func handleViewDidLoad() async {
        let isLogin = await checkFullAuthentication.execute()
        mutate { $0.isGuest = !isLogin }
    }

    private func handleType(_ type: SettingItemType) {
        switch type {
        case .notice:
            navigate(to: .noticeList)

        case .term,
             .feedback,
             .faq:
            guard let url = URL(string: type.url) else { return }
            emit(.showSFView(url))

        case .logout:
            emit(.showLogoutAlert)

        case .withdraw:
            navigate(to: .withdraw)

        default:
            break
        }
    }
}
