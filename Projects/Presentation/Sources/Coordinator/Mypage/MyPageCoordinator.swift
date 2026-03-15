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
            showSetting()

        case .noticeList:
            showNoticeList()

        case let .noticeDetail(id):
            showNoticeDetail(id: id)

        case .withdraw:
            showWithdraw()

        case .withdrawComplete:
            showWithdrawComplete()

        case let .souvenirRoute(sovenirRoute):
            handleSouvenirRoute(sovenirRoute)

        case .login:
            navigateToParent(.login)

        case .loginBottomSheet:
            showLoginBottomSheet()

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

    func showSetting() {
        let scene = factory.makeSetting()
        scene.vc.hidesBottomBarWhenPushed = true
        bindRoute(scene)
        nav.pushViewController(scene.vc, animated: true)
    }

    func showNoticeList() {
        let scene = factory.makeNoticeList()
        scene.vc.hidesBottomBarWhenPushed = true
        bindRoute(scene)
        nav.pushViewController(scene.vc, animated: true)
    }

    func showNoticeDetail(id: Int) {
        let scene = factory.makeNoticeDetail(id: id)
        scene.vc.hidesBottomBarWhenPushed = true
        bindRoute(scene)
        nav.pushViewController(scene.vc, animated: true)
    }

    func showWithdraw() {
        let scene = factory.makeWithdraw()
        scene.vc.hidesBottomBarWhenPushed = true
        bindRoute(scene)
        nav.pushViewController(scene.vc, animated: true)
    }

    func showWithdrawComplete() {
        let scene = factory.makeWithdrawComplete()
        scene.vc.hidesBottomBarWhenPushed = true
        bindRoute(scene)
        nav.pushViewController(scene.vc, animated: true)
    }

    func refreshMyPage() {
        let scene = factory.makeMyPageScene()
        bindRoute(scene)
        nav.setViewControllers([scene.vc], animated: false)
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

    func showLoginBottomSheet() {
        let coordinator = LoginBottomSheetCoordinator(
            nav: nav,
            factory: factory
        )
        coordinator.onFinish = { [weak self] in
            self?.refreshMyPage()
        }
        addTemporaryChild(coordinator)
        coordinator.start()
    }
}
