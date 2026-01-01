import UIKit

final class HomeCoordinator: BaseCoordinator<HomeRoute, TabRoute> {
    private let factory: PresentationFactory

    init(nav: UINavigationController, factory: PresentationFactory) {
        self.factory = factory
        super.init(nav: nav)
    }

    override func start() {
        navigate(.globe)
    }

    override func navigate(_ route: Route) {
        switch route {
        case .globe:
            showGlobe()

        case .createSouvenir:
            showCreateSouvenir()

        case let .searchCountry(onResult):
            showSearchCountry(onResult)

        case .pop:
            nav.popViewController(animated: true)

        case .dismiss:
            nav.dismiss(animated: true)
        }
    }
}

private extension HomeCoordinator {
    func showGlobe() {
        let scene = factory.makeGlobeScene()
        bindRoute(scene)
        nav.setViewControllers([scene.vc], animated: true)
    }

    func showCreateSouvenir() {
        let coordinator = SouvenirCoordinator(
            nav: nav,
            factory: factory
        )

        addTemporaryChild(coordinator)
        coordinator.navigate(.create)
    }

    func showSearchCountry(_ onResult: @escaping (SearchResultItem) -> Void) {
        let coordinator = SouvenirCoordinator(
            nav: nav,
            factory: factory
        )

        addTemporaryChild(coordinator)
        coordinator.navigate(.search(onResult: onResult))
    }
}
