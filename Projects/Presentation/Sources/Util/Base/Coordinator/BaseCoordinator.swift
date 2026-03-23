import Logger
import UIKit

@MainActor
public class BaseCoordinator<Route, ParentRoute>: Coordinator {
    public let nav: UINavigationController
    public var children: [any Coordinator] = []
    public weak var parent: (any Coordinator)?

    public var sendParentRoute: ((ParentRoute) -> Void)?
    public var onFinish: (() -> Void)?

    public init(nav: UINavigationController) {
        self.nav = nav
        Logger.shared.logLifecycle(caller: self)
    }

    deinit {
        Logger.shared.logLifecycle(caller: self)
    }

    public func start() {}
    public func navigate(_ route: Route) {}
    public func navigateToParent(_ route: ParentRoute) {
        sendParentRoute?(route)
    }

    public func finish() {
        onFinish?()
    }
}
