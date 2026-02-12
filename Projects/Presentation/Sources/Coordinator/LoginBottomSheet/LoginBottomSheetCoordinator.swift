import DesignSystem
import Domain
import RxSwift
import UIKit

final class LoginBottomSheetCoordinator: BaseCoordinator<LoginBottomSheetRoute, Void> {
    private let factory: PresentationAuthFactory

    init(
        nav: UINavigationController,
        factory: PresentationAuthFactory
    ) {
        self.factory = factory
        super.init(nav: nav)
    }

    // MARK: - Start

    override func start() {
        navigate(.login)
    }

    // MARK: - Navigate

    override func navigate(_ route: Route) {
        switch route {
        case .login:
            showLoginBottomSheet()

        case .terms:
            nav.dismiss(animated: false)
            showTerms()

        case .profile:
            showProfile()

        case .category:
            showCategory()

        case .complete:
            finish()

        case .back:
            nav.popViewController(animated: true)

        case .pop:
            nav.dismiss(animated: false)
        }
    }
}

private extension LoginBottomSheetCoordinator {
    func showLoginBottomSheet() {
        let scene = factory.makeLoginBottomSheetScene()
        scene.vc.hidesBottomBarWhenPushed = true
        bindRoute(scene)
        nav.present(scene.vc, animated: false)
    }

    func showTerms() {
        let scene = factory.makeTermsScene()
        scene.vc.hidesBottomBarWhenPushed = true
        bindRoute(scene, mapper: mapAuthRoute)
        nav.pushViewController(scene.vc, animated: true)
    }

    func showProfile() {
        let scene = factory.makeProfileScene()
        scene.vc.hidesBottomBarWhenPushed = true
        bindRoute(scene, mapper: mapAuthRoute)
        nav.pushViewController(scene.vc, animated: true)
    }

    func showCategory() {
        let scene = factory.makeCategoryScene()
        scene.vc.hidesBottomBarWhenPushed = true
        bindRoute(scene, mapper: mapAuthRoute)
        nav.pushViewController(scene.vc, animated: true)
    }
}

private extension LoginBottomSheetCoordinator {
    func mapAuthRoute(_ authRoute: AuthRoute) -> LoginBottomSheetRoute {
        switch authRoute {
        case .back: .back
        case .category: .category
        case .main: .complete
        case .profile: .profile
        case .terms: .terms
        default: .back
        }
    }
}
