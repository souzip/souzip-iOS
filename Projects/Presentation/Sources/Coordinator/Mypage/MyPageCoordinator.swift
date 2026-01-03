import UIKit

final class MyPageCoordinator: BaseCoordinator<MyPageRoute, TabRoute> {
    private let factory: PresentationFactory

    init(nav: UINavigationController, factory: PresentationFactory) {
        self.factory = factory
        super.init(nav: nav)
    }

    override func start() {
        navigate(.myPage)
    }

    override func navigate(_ route: Route) {
        switch route {
        case .myPage:
            showMyPage()

        case .setting:
            break

        case let .souvenirRoute(sovenirRoute):
            handleSouvenirRoute(sovenirRoute)

        case .pop:
            nav.popViewController(animated: true)

        case .dismiss:
            nav.dismiss(animated: true)
        }
    }
}

private extension MyPageCoordinator {
    func showMyPage() {
        let scene = factory.makeMyPageScene()
        bindRoute(scene)
        nav.setViewControllers([scene.vc], animated: true)
    }
}

private extension MyPageCoordinator {
    func handleSouvenirRoute(_ route: SouvenirRoute) {
        let coordinator = SouvenirCoordinator(
            nav: nav,
            factory: factory
        )

        addTemporaryChild(coordinator)
        coordinator.navigate(route)
    }
}
