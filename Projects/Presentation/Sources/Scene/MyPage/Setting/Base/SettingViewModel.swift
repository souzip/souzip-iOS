import Domain
import Foundation

final class SettingViewModel: BaseViewModel<
    SettingState,
    SettingAction,
    SettingEvent,
    MyPageRoute
> {
    // MARK: - Repository

    private let authRepo: AuthRepository

    // MARK: - Init

    init(
        authRepo: AuthRepository
    ) {
        self.authRepo = authRepo
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
                try? await authRepo.logout()
                navigate(to: .login)
            }

        case .withdraw:
            Task {
                try? await authRepo.withdraw()
                navigate(to: .login)
            }
        }
    }

    // MARK: - Private Logic

    private func handleViewDidLoad() async {
        let isLogin = await authRepo.isFullyAuthenticated()
        mutate { $0.isGuest = !isLogin }
    }

    private func handleType(_ type: SettingItemType) {
        switch type {
        case .termsOfService,
             .privacyPolicy,
             .locationTerms,
             .marketingConsentInfo,
             .notice,
             .feedback,
             .faq:
            guard let url = URL(string: type.url) else { return }
            emit(.showSFView(url))

        case .logout:
            emit(.showLogoutAlert)

        case .withdraw:
            emit(.showWithdrawAlert)

        default:
            break
        }
    }
}
