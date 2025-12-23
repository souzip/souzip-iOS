import RxCocoa
import RxSwift

protocol ActionBindable: AnyObject {
    associatedtype Action

    var action: PublishRelay<Action> { get }
    var disposeBag: DisposeBag { get }
}
