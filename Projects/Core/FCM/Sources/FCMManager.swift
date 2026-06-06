import FirebaseCore
import FirebaseMessaging
import Logger

public final class FCMManager: NSObject, FCMTokenProviding {
    public static let shared = FCMManager()

    private let tokenStore = FCMTokenStore()

    public func currentToken() async -> String? {
        await tokenStore.currentToken()
    }

    // swiftformat:disable:next modifierOrder
    private override init() {
        super.init()
    }

    // MARK: - Token

    public func fcmTokenUpdates() -> AsyncStream<String> {
        let tokenStore = tokenStore

        return AsyncStream { continuation in
            let streamID = UUID()

            Task {
                await tokenStore.registerStream(
                    id: streamID,
                    continuation: continuation
                )
            }

            continuation.onTermination = { @Sendable _ in
                Task {
                    await tokenStore.unregisterStream(id: streamID)
                }
            }
        }
    }

    // MARK: - Bootstrap

    public func configure() {
        guard FirebaseApp.app() == nil else { return }

        FirebaseApp.configure()
        Messaging.messaging().delegate = self

        Logger.shared.info("Firebase 초기화 완료", category: .general)
    }

    public func setAPNSToken(_ deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken

        Logger.shared.info(
            "APNs device token 등록 완료",
            category: .general
        )
    }

    private func deliverToken(_ token: String) {
        Task {
            let isNewToken = await tokenStore.updateToken(token)
            guard isNewToken else { return }

            #if DEBUG
                Logger.shared.debug("FCM 토큰: \(token)", category: .general)
            #else
                Logger.shared.info("FCM 토큰 갱신됨", category: .general)
            #endif
        }
    }
}

// MARK: - MessagingDelegate

extension FCMManager: MessagingDelegate {
    public func messaging(
        _ messaging: Messaging,
        didReceiveRegistrationToken fcmToken: String?
    ) {
        guard let fcmToken else { return }

        deliverToken(fcmToken)
    }
}
