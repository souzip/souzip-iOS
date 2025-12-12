import Logger
import UIKit

@MainActor
open class BaseCoordinator<Route>: Coordinator {
    public let nav: UINavigationController
    public var children: [any Coordinator] = []
    public weak var parent: (any Coordinator)?

    public init(nav: UINavigationController) {
        self.nav = nav
        Logger.shared.logLifecycle()
    }

    deinit {
        Logger.shared.logLifecycle()
    }

    open func start() {}

    open func navigate(_ route: Route) {
        Logger.shared.logRoute(route)
    }
}
