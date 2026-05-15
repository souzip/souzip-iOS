import Domain
import RxRelay
import RxSwift

/// 풀 인증 여부의 단일 출처. UseCase 호출은 이 타입 내부에서만 수행한다.
final class AuthSessionStore {
    private let checkFullAuthentication: CheckFullAuthenticationUseCase

    let isFullyAuthenticated: BehaviorRelay<Bool>

    /// ViewModel은 판정이 아니라 “값이 바뀌었음”만 구독해 반응하면 된다.
    var authStateChanges: Observable<Bool> {
        isFullyAuthenticated.asObservable().distinctUntilChanged()
    }

    init(checkFullAuthentication: CheckFullAuthenticationUseCase) {
        self.checkFullAuthentication = checkFullAuthentication
        isFullyAuthenticated = BehaviorRelay(value: false)
        Task { await refreshSession() }
    }

    func refreshSession() async {
        let value = await checkFullAuthentication.execute()
        isFullyAuthenticated.accept(value)
    }
}
