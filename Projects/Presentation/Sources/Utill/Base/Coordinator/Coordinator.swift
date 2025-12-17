import RxRelay
import RxSwift
import UIKit

@MainActor
public protocol Coordinator: AnyObject {
    associatedtype Route

    var nav: UINavigationController { get }
    var parent: (any Coordinator)? { get set }
    var children: [any Coordinator] { get set }

    func start()
    func navigate(_ route: Route)
}

public extension Coordinator {
    func addChild(_ coordinator: any Coordinator) {
        coordinator.parent = self
        children.append(coordinator)
    }

    func removeChild(_ coordinator: any Coordinator) {
        children.removeAll { $0 === coordinator }
    }

    func removeAllChild() {
        children.removeAll()
    }
}

public extension Coordinator {
    /// ViewModel Route를 Coordinator Route로 매핑하여 자동 바인딩
    func bindRoute<VMRoute>(
        _ routeRelay: PublishRelay<VMRoute>,
        mapper: @escaping (VMRoute) -> Route,
        disposeBag: DisposeBag
    ) {
        routeRelay
            .subscribe { [weak self] vmRoute in
                let coordinatorRoute = mapper(vmRoute)
                self?.navigate(coordinatorRoute)
            }
            .disposed(by: disposeBag)
    }

    /// ViewModel Route와 Coordinator Route가 같을 때 (매핑 불필요)
    func bindRoute(
        _ routeRelay: PublishRelay<Route>,
        disposeBag: DisposeBag
    ) {
        routeRelay
            .subscribe { [weak self] route in
                self?.navigate(route)
            }
            .disposed(by: disposeBag)
    }
}
