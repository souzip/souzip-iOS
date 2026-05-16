import RxRelay
import RxSwift

/// 마이페이지 등에 표시하는 사용자 기념품 컬렉션이 stale일 수 있음을 알린다.
final class UserSouvenirInvalidationStore {
    private let didChange = PublishRelay<Void>()

    /// CUD 성공 직후에만 호출한다.
    func notifyUserSouvenirsChanged() {
        didChange.accept(())
    }

    var userSouvenirCollectionDidChange: Observable<Void> {
        didChange.asObservable()
    }
}
