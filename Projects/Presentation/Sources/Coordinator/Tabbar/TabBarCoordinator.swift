import UIKit

final class TabBarCoordinator: BaseCoordinator<TabItem, RootRoute> {
    private let factory: PresentationFactory

    private let tabBar = UITabBarController()

    private let tab1Nav = UINavigationController()
    private let tab2Nav = UINavigationController()
    private let tab3Nav = UINavigationController()

    init(
        nav: UINavigationController,
        factory: PresentationFactory
    ) {
        self.factory = factory
        super.init(nav: nav)
    }

    override func start() {
        setupTabBar()
        navigate(.tab1)
    }

    override func navigate(_ route: Route) {
        tabBar.selectedIndex = route.rawValue
    }
}

private extension TabBarCoordinator {
    func setupTabBar() {
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

        nav.setViewControllers([tabBar], animated: false)
    }
}
