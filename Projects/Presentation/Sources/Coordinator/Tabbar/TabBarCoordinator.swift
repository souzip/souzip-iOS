import UIKit

public final class TabBarCoordinator: Coordinator {
    public typealias Route = TabBarRoute

    public let nav: UINavigationController
    public weak var parent: (any Coordinator)?
    public var children: [any Coordinator] = []

    private let factory: PresentationFactory

    private let tabBar = UITabBarController()

    private let tab1Nav = UINavigationController()
    private let tab2Nav = UINavigationController()
    private let tab3Nav = UINavigationController()

    public init(
        nav: UINavigationController,
        factory: PresentationFactory
    ) {
        self.nav = nav
        self.factory = factory
    }

    public func navigate(_ route: Route, animated: Bool) {
        switch route {
        case .initial:
            setupTabs(animated)

        case let .select(tab):
            tabBar.selectedIndex = tab.rawValue
        }
    }
}

private extension TabBarCoordinator {
    func setupTabs(_ animated: Bool) {
        let tab1VC = UIViewController()
        tab1VC.view.backgroundColor = .red

        let tab2VC = UIViewController()
        tab2VC.view.backgroundColor = .green

        let tab3VC = UIViewController()
        tab3VC.view.backgroundColor = .blue

        tabBar.viewControllers = [
            tab1VC,
            tab2VC,
            tab3VC,
        ]

        nav.setViewControllers([tabBar], animated: animated)
    }
}
