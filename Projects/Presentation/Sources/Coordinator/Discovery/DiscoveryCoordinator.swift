import UIKit

final class DiscoveryCoordinator: BaseCoordinator<DiscoveryRoute, TabRoute> {
    private let factory: PresentationFactory

    init(nav: UINavigationController, factory: PresentationFactory) {
        self.factory = factory
        super.init(nav: nav)
    }

    override func start() {
        navigate(.discovery)
    }

    override func navigate(_ route: Route) {
        switch route {
        case .discovery:
            showDiscovery()

        case .recommend:
            showRecommend()

        case let .souvenirRoute(souvenirRoute):
            handleSouvenirRoute(souvenirRoute)

        case .pop:
            nav.popViewController(animated: true)

        case .dimiss:
            nav.dismiss(animated: true)
        }
    }
}

private extension DiscoveryCoordinator {
    func showDiscovery() {
        let scene = factory.makeDiscoveryScene()
        bindRoute(scene)
        nav.setViewControllers([scene.vc], animated: false)
    }

    func showRecommend() {
        let scene = factory.makeRecommendScene()
        bindRoute(scene)
        nav.pushViewController(scene.vc, animated: true)
    }
}

private extension DiscoveryCoordinator {
    func handleSouvenirRoute(_ route: SouvenirRoute) {
        let coordinator = SouvenirCoordinator(
            nav: nav,
            factory: factory
        )

        addTemporaryChild(coordinator)
        coordinator.navigate(route)
    }
}
