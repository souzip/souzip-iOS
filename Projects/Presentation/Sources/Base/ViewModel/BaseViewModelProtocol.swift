import RxRelay
import RxSwift

protocol BaseViewModelProtocol: AnyObject {
    associatedtype State
    associatedtype Action
    associatedtype Event
    associatedtype Route

    var stateRelay: BehaviorRelay<State> { get }
    var actionRelay: PublishRelay<Action> { get }
    var eventRelay: PublishRelay<Event> { get }
    var routeRelay: PublishRelay<Route> { get }
}
