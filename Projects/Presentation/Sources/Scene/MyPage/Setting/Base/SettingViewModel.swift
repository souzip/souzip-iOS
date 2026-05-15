import Domain
import Foundation
import RxCocoa
import RxSwift

final class SettingViewModel: BaseViewModel<
    SettingState,
    SettingAction,
    SettingEvent,
    MyPageRoute
> {
    // MARK: - UseCase

    private let authSessionStore: AuthSessionStore
    private let logout: LogoutUseCase

    // MARK: - Init

    init(
        authSessionStore: AuthSessionStore,
        logout: LogoutUseCase
    ) {
        self.authSessionStore = authSessionStore
        self.logout = logout
        super.init(initialState: State())
        bindAuthSessionStore()
    }

    // MARK: - Action Handling

    override func handleAction(_ action: Action) {
        switch action {
        case .viewDidLoad:
            break

        case .back:
            navigate(to: .pop)

        case let .tapItem(type):
            handleType(type)

        case .logout:
            Task {
                try? await logout.execute()
                await authSessionStore.refreshSession()
                navigate(to: .login)
            }
        }
    }

    // MARK: - Private Logic

    private func bindAuthSessionStore() {
        authSessionStore.authStateChanges
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLogin in
                self?.mutate { $0.isGuest = !isLogin }
            })
            .disposed(by: disposeBag)
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
