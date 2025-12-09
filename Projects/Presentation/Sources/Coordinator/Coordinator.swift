import UIKit

@MainActor
public protocol Coordinator: AnyObject {
    associatedtype Route

    var nav: UINavigationController { get }
    var parent: (any Coordinator)? { get set }
    var children: [any Coordinator] { get set }

    func navigate(_ route: Route, animated: Bool)
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
