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
        }
    }
}

private extension MyPageCoordinator {
    func showMyPage() {
        let vc = UIViewController()
        vc.view.backgroundColor = .green
        nav.setViewControllers([vc], animated: false)
    }
}
