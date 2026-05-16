import Domain
import RxRelay
import RxSwift

/// 풀 인증 여부의 단일 출처. UseCase 호출은 이 타입 내부에서만 수행한다.
final class AuthSessionStore {
    private let checkFullAuthentication: CheckFullAuthenticationUseCase

    private let isFullyAuthenticatedRelay: BehaviorRelay<Bool>

    /// 동기 시점의 풀 인증 여부(구독 없이 한 번만 읽을 때).
    var isFullyAuthenticatedValue: Bool {
        isFullyAuthenticatedRelay.value
    }

    /// ViewModel은 판정이 아니라 “값이 바뀌었음”만 구독해 반응하면 된다.
    var authStateChanges: Observable<Bool> {
        isFullyAuthenticatedRelay.asObservable().distinctUntilChanged()
    }

    init(checkFullAuthentication: CheckFullAuthenticationUseCase) {
        self.checkFullAuthentication = checkFullAuthentication
        isFullyAuthenticatedRelay = BehaviorRelay(value: false)
        Task { await refreshSession() }
    }

    func refreshSession() async {
        let value = await checkFullAuthentication.execute()
        isFullyAuthenticatedRelay.accept(value)
    }
}
