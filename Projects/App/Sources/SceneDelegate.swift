import Data
import DesignSystem
import Domain
import Networking
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

        FontRegistration.register()

        let nav = UINavigationController()
        let factory = AppFactory()

        coordinator = AppCoordinator(
            nav: nav,
            factory: factory.presentationFactory
        )
        coordinator?.start()

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        _ = AuthRedirect.handle(url: url)
    }
}
