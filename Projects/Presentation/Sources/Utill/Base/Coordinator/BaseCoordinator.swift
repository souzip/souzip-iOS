import Logger
import UIKit

@MainActor
open class BaseCoordinator<Route>: Coordinator {
    public let nav: UINavigationController
    public var children: [any Coordinator] = []
    public weak var parent: (any Coordinator)?

    public init(nav: UINavigationController) {
        self.nav = nav
        Logger.shared.logLifecycle(caller: self)
    }

    deinit {
        Logger.shared.logLifecycle(caller: self)
    }

    open func start() {}

    open func navigate(_ route: Route) {}
}
