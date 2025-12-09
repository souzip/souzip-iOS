import Presentation
import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private var coordinator: AppCoordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let nav = UINavigationController()

        let dataFactory = DefaultDataFactory()
        let domainFactory = DefaultDomainFactory(factory: dataFactory)
        let presentationFactory = DefaultPresentationFactory(factory: domainFactory)

        coordinator = AppCoordinator(
            nav: nav,
            factory: presentationFactory
        )
        coordinator?.navigate(.initial, animated: false)

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
}
