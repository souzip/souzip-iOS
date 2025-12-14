import RxRelay
import RxSwift

protocol BaseViewModelType: AnyObject {
    associatedtype State
    associatedtype Action
    associatedtype Event
    associatedtype Route

    var state: BehaviorRelay<State> { get }
    var action: PublishRelay<Action> { get }
    var event: PublishRelay<Event> { get }
    var route: PublishRelay<Route> { get }
}
