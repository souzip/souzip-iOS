import Data
import Presentation
import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private var coordinator: RootCoordinator?
    private let pushNotificationRegistrar = PushNotificationRegistrar()

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let config = AppConfiguration()
        pushNotificationRegistrar.requestPermissionIfNeeded()

        let factory = AppFactory(config: config)

        let nav = CommonNavigationController()

        coordinator = RootCoordinator(
            nav: nav,
            factory: factory.domainFactory
        )
        coordinator?.start()

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        pushNotificationRegistrar.syncRegistrationIfAuthorized()
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        AuthRedirect.handle(url: url)
    }
}
