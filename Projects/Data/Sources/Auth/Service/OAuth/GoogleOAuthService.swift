import GoogleSignIn
import UIKit

public final class GoogleOAuthService: OAuthService {
    private let clientID: String

    public init(clientID: String) {
        self.clientID = clientID
    }

    @MainActor
    public func login() async throws -> String {
        do {
            GIDSignIn.sharedInstance.configuration = GIDConfiguration(
                clientID: clientID
            )

            guard let presentingVC = topMostViewController() else {
                throw OAuthServiceError.notSupported
            }

            let result = try await GIDSignIn.sharedInstance.signIn(
                withPresenting: presentingVC
            )

            return result.user.accessToken.tokenString
        } catch is CancellationError {
            throw OAuthServiceError.cancelled
        } catch {
            throw OAuthServiceError.sdkError(error)
        }
    }
}

// MARK: - Private Helpers

private extension GoogleOAuthService {
    func topMostViewController() -> UIViewController? {
        guard let rootViewController = UIApplication.shared
            .connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap(\.windows)
            .first(where: { $0.isKeyWindow })?
            .rootViewController
        else {
            return nil
        }

        return findTopViewController(from: rootViewController)
    }

    func findTopViewController(from viewController: UIViewController) -> UIViewController {
        if let navigationController = viewController as? UINavigationController,
           let visibleViewController = navigationController.visibleViewController {
            return findTopViewController(from: visibleViewController)
        }

        if let tabBarController = viewController as? UITabBarController,
           let selectedViewController = tabBarController.selectedViewController {
            return findTopViewController(from: selectedViewController)
        }

        if let presentedViewController = viewController.presentedViewController {
            return findTopViewController(from: presentedViewController)
        }

        return viewController
    }
}
