import CoreLocation
import Domain
import UIKit

final class SouvenirCoordinator: BaseCoordinator<SouvenirRoute, Never> {
    private let factory: PresentationSouvenirFactory

    private weak var modalNav: UINavigationController?

    init(nav: UINavigationController, factory: PresentationSouvenirFactory) {
        self.factory = factory
        super.init(nav: nav)
    }

    override func navigate(_ route: Route) {
        switch route {
        case .create:
            showCreateSouvenir()

        case let .edit(detail, onResult):
            showEditSouvenir(detail, onResult)

        case .detail:
            showDetailSouvenir()

        case let .search(onResult):
            showSearch(onResult: onResult)

        case let .locationPicker(initial, onComplete):
            showLocationPicker(
                initialCoordinate: initial,
                onComplete: onComplete
            )

        case let .categoryPicker(initial, onComplete):
            showCategoryPicker(
                initial,
                onComplete
            )

        case .pop:
            handlePop()

        case .dismiss:
            handleDismiss()

        case .poptoForm:
            popToForm()

        case .finish:
            finish()
        }
    }
}

private extension SouvenirCoordinator {
    // MARK: - Present (Create / Edit)

    func showCreateSouvenir() {
        let scene = factory.makeSouvenirFormScene(mode: .create)
        bindRoute(scene)

        let modal = CommonNavigationController(rootViewController: scene.vc)
        modal.modalPresentationStyle = .fullScreen

        modalNav = modal
        nav.present(modal, animated: true)
    }

    func showEditSouvenir(
        _ detail: SouvenirDetail,
        _ onResult: (SouvenirDetail) -> Void
    ) {
        let scene = factory.makeSouvenirFormScene(mode: .edit(detail))
        bindRoute(scene)

        let modal = CommonNavigationController(rootViewController: scene.vc)
        modal.modalPresentationStyle = .fullScreen

        modalNav = modal
        nav.present(modal, animated: true)
    }

    // MARK: - Detail

    func showDetailSouvenir() {
        let vc = UIViewController()
        vc.view.backgroundColor = .green
        activeNav().setViewControllers([vc], animated: false)
    }

    // MARK: - Push

    func showSearch(onResult: @escaping (SearchResultItem) -> Void) {
        let scene = factory.makeSearchScene(onResult: onResult)
        bindRoute(scene)
        activeNav().pushViewController(scene.vc, animated: true)
    }

    func showLocationPicker(
        initialCoordinate: CLLocationCoordinate2D,
        onComplete: @escaping (CLLocationCoordinate2D, String) -> Void
    ) {
        let scene = factory.makeLocationPicker(
            initialCoordinate: initialCoordinate,
            onComplete: onComplete
        )
        bindRoute(scene)
        activeNav().pushViewController(scene.vc, animated: true)
    }

    func showCategoryPicker(
        _ initialCategory: SouvenirCategory?,
        _ onComplete: @escaping (SouvenirCategory) -> Void
    ) {
        let scene = factory.makeCategoryPicker(
            initailCategory: initialCategory,
            onComplete: onComplete
        )
        bindRoute(scene)
        activeNav().pushViewController(scene.vc, animated: true)
    }
}

private extension SouvenirCoordinator {
    var activeNavForPush: UINavigationController {
        modalNav ?? nav
    }

    func activeNav() -> UINavigationController {
        modalNav ?? nav
    }

    func handlePop() {
        let currentNav = activeNav()

        if currentNav.viewControllers.count > 1 {
            currentNav.popViewController(animated: true)
            return
        }

        // pop 불가 → 흐름 종료
        if let modal = modalNav {
            modal.dismiss(animated: true)
            modalNav = nil
        }

        finish()
    }

    func handleDismiss() {
        if let modal = modalNav {
            modal.dismiss(animated: true)
            modalNav = nil
        }

        finish()
    }

    func popToForm() {
        let currentNav = activeNav()

        if let formVC = currentNav.viewControllers.first(
            where: { $0 is SouvenirFormViewController }
        ) {
            currentNav.popToViewController(formVC, animated: true)
        } else {
            handlePop()
        }
    }
}
