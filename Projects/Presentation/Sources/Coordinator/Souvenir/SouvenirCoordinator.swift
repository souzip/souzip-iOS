import CoreLocation
import Domain
import UIKit

final class SouvenirCoordinator: BaseCoordinator<SouvenirRoute, Never> {
    private let factory: PresentationSouvenirFactory

    init(nav: UINavigationController, factory: PresentationSouvenirFactory) {
        self.factory = factory
        super.init(nav: nav)
    }

    override func start() {}

    override func navigate(_ route: Route) {
        switch route {
        case .create:
            showCreateSouvenir()

        case .detail:
            showDetailSouvenir()

        case let .edit(detail, onResult):
            showEditSouvenir()

        case let .search(onResult):
            showSearch(onResult: onResult)

        case let .locationPicker(initiail, onComplete):
            showLocationPicker(initialCoordinate: initiail, onComplete: onComplete)

        case let .categoryPicker(initial, onComplete):
            showCategoryPicker(initial, onComplete)

        case .pop:
            nav.popViewController(animated: true)

        case .dismiss:
            nav.dismiss(animated: true)

        case .poptoForm:
            popToForm()

        case .finish:
            finish()
        }
    }
}

private extension SouvenirCoordinator {
    func showCreateSouvenir() {
        let scene = factory.makeSouvenirFormScene(mode: .create)
        bindRoute(scene)
        let modalNav = CommonNavigationController(rootViewController: scene.vc)
        modalNav.modalPresentationStyle = .fullScreen
        nav.present(modalNav, animated: true)
    }

    func showDetailSouvenir() {
        let vc = UIViewController()
        vc.view.backgroundColor = .green
        nav.setViewControllers([vc], animated: false)
    }

    func showEditSouvenir(
        _ detail: SouvenirDetail,
        _ onResult: (SouvenirDetail) -> Void
    ) {
        let scene = factory.makeSouvenirFormScene(mode: .edit(detail))
        bindRoute(scene)
        let modalNav = CommonNavigationController(rootViewController: scene.vc)
        modalNav.modalPresentationStyle = .fullScreen
        nav.present(modalNav, animated: true)
    }

    func showLocationPicker(
        initialCoordinate: CLLocationCoordinate2D,
        onComplete: @escaping (CLLocationCoordinate2D, String) -> Void
    ) {
        let scene = factory.makeLocationPicker(
            initialCoordinate: initialCoordinate,
            onComplete: onComplete
        )
        scene.vc.hidesBottomBarWhenPushed = true
        bindRoute(scene)
        nav.pushViewController(scene.vc, animated: true)
    }

    func showCategoryPicker(
        _ initialCategory: SouvenirCategory?,
        _ onComplete: @escaping (SouvenirCategory) -> Void
    ) {
        let scene = factory.makeCategoryPicker(
            initailCategory: initialCategory,
            onComplete: onComplete
        )
        scene.vc.hidesBottomBarWhenPushed = true
        bindRoute(scene)
        nav.pushViewController(scene.vc, animated: true)
    }

    func showSearch(onResult: @escaping (SearchResultItem) -> Void) {
        let scene = factory.makeSearchScene(onResult: onResult)
        scene.vc.hidesBottomBarWhenPushed = true
        bindRoute(scene)
        nav.pushViewController(scene.vc, animated: true)
    }

    func popToForm() {
        if let formVC = nav.viewControllers.first(where: { $0 is SouvenirFormViewController }) {
            nav.popToViewController(formVC, animated: true)
        }
    }
}
