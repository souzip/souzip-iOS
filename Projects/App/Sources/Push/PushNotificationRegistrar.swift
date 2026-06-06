import Logger
import UIKit
import UserNotifications

/// 푸시 권한 요청·APNs 등록은 App 레이어 책임. Core FCM은 토큰 수신만 담당한다.
final class PushNotificationRegistrar {
    private enum UserDefaultsKey {
        static let hasPresentedPushPermissionPrompt = "push.hasPresentedPermissionPrompt"
    }

    func requestPermissionIfNeeded() {
        if UserDefaults.standard.bool(forKey: UserDefaultsKey.hasPresentedPushPermissionPrompt) {
            syncRegistrationIfAuthorized()
            return
        }

        UNUserNotificationCenter.current().requestAuthorization(options: [
            .alert,
            .badge,
            .sound,
        ]) { granted, error in
            UserDefaults.standard.set(
                true,
                forKey: UserDefaultsKey.hasPresentedPushPermissionPrompt
            )

            if let error {
                Logger.shared.error(
                    "푸시 권한 요청 실패: \(error.localizedDescription)",
                    category: .general
                )
                return
            }

            Logger.shared.info(
                "푸시 권한 \(granted ? "허용" : "거부")",
                category: .general
            )

            guard granted else { return }

            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }

    /// 설정 앱에서 권한을 켠 뒤 앱으로 돌아온 경우 등 APNs 재등록
    func syncRegistrationIfAuthorized() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else { return }

            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
}
