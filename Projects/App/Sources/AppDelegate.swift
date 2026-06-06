import FCM
import Logger
import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    private let fcmTokenProvider: FCMTokenProviding = DefaultFCMFactory.shared.makeFCMTokenProvider()
    private let pushTokenSyncer: PushTokenSyncing = DeferredPushTokenSyncer()
    private var pushTokenSyncTask: Task<Void, Never>?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        fcmTokenProvider.configure()
        observeFCMTokenUpdates()
        return true
    }

    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        fcmTokenProvider.setAPNSToken(deviceToken)
    }

    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        Logger.shared.error(
            "APNs 등록 실패: \(error.localizedDescription)",
            category: .general
        )
    }

    private func observeFCMTokenUpdates() {
        pushTokenSyncTask?.cancel()

        let tokenUpdates = fcmTokenProvider.fcmTokenUpdates()
        let pushTokenSyncer = pushTokenSyncer

        pushTokenSyncTask = Task {
            for await token in tokenUpdates {
                await pushTokenSyncer.sync(fcmToken: token)
            }
        }
    }

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role
        )
    }
}
