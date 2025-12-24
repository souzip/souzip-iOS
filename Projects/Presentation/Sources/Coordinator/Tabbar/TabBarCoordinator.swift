import UIKit

final class TabBarCoordinator: BaseCoordinator<TabRoute, RootRoute> {
    private let factory: PresentationFactory

    private let tabController = CommonTabbarController()

    private let homeNav = CommonNavigationController()
    private let discoveryNav = CommonNavigationController()
    private let myPageNav = CommonNavigationController()

    private var selectedTab: TabRoute = .home

    init(nav: UINavigationController, factory: PresentationFactory) {
        self.factory = factory
        super.init(nav: nav)
    }

    override func start() {
        setupChildCoordinators()
        setupTabController()
        navigate(.home)
    }

    override func navigate(_ route: Route) {
        selectedTab = route

        switch route {
        case .home:
            tabController.setSelectedIndex(route.rawValue)
            tabController.showContent(homeNav)

        case .discovery:
            tabController.setSelectedIndex(route.rawValue)
            tabController.showContent(discoveryNav)

        case .myPage:
            tabController.setSelectedIndex(route.rawValue)
            tabController.showContent(myPageNav)
        }
    }
}

// MARK: - Private Methods

private extension TabBarCoordinator {
    func setupChildCoordinators() {
        let home = HomeCoordinator(nav: homeNav, factory: factory)
        let discovery = DiscoveryCoordinator(nav: discoveryNav, factory: factory)
        let myPage = MyPageCoordinator(nav: myPageNav, factory: factory)

        addChild(home)
        addChild(discovery)
        addChild(myPage)

        home.start()
        discovery.start()
        myPage.start()
    }

    func setupTabController() {
        tabController.setTabs(TabRoute.items)
        tabController.onTabTapped = { [weak self] route in
            guard let self else { return }

            if route == selectedTab {
                handleTabReselected(route)
            } else {
                navigate(route)
            }
        }

        nav.setViewControllers([tabController], animated: false)
    }

    func handleTabReselected(_ tab: TabRoute) {
        switch tab {
        case .home:
            homeNav.popToRootViewController(animated: true)
        case .discovery:
            discoveryNav.popToRootViewController(animated: true)
        case .myPage:
            myPageNav.popToRootViewController(animated: true)
        }
    }
}
