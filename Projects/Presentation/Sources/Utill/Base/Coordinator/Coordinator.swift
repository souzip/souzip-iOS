import RxCocoa
import RxSwift
import UIKit

@MainActor
public protocol Coordinator: AnyObject {
    associatedtype Route
    associatedtype ParentRoute

    var nav: UINavigationController { get }
    var parent: (any Coordinator)? { get set }
    var children: [any Coordinator] { get set }

    func start()
    func navigate(_ route: Route)
    func navigateToParent(_ route: ParentRoute)
}

public extension Coordinator {
    func addChild<C: Coordinator>(_ child: C) where C.ParentRoute == Route {
        child.parent = self
        if let baseChild = child as? BaseCoordinator<C.Route, C.ParentRoute> {
            baseChild.sendParentRoute = { [weak self] parentRoute in
                self?.navigate(parentRoute)
            }
        }
        children.append(child)
    }

    func addTemporaryChild<C: Coordinator>(
        _ child: C,
    ) {
        child.parent = self

        // BaseCoordinator의 completion 설정
        if child is BaseCoordinator<C.Route, C.ParentRoute> {
            removeChild(child)
        }

        children.append(child)
    }

    func removeChild(_ coordinator: any Coordinator) {
        children.removeAll { $0 === coordinator }
    }

    func removeAllChild() {
        children.removeAll()
    }
}

// MARK: - RoutedScene Binding

public extension Coordinator {
    func bindRoute(_ scene: RoutedScene<Route>) {
        scene.route
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .asSignal(onErrorSignalWith: .empty())
            .emit { [weak self] route in
                self?.navigate(route)
            }
            .disposed(by: scene.disposeBag)
    }

    func bindRoute<VMRoute>(
        _ scene: RoutedScene<VMRoute>,
        mapper: @escaping (VMRoute) -> Route
    ) {
        scene.route
            .asSignal()
            .emit { [weak self] vmRoute in
                let coordinatorRoute = mapper(vmRoute)
                self?.navigate(coordinatorRoute)
            }
            .disposed(by: scene.disposeBag)
    }
}
