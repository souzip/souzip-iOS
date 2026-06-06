import Logger

protocol PushTokenSyncing: AnyObject {
    func sync(fcmToken: String) async
}

/// 서버 API 스펙이 연결되기 전까지 토큰 수신 지점만 고정한다.
final class DeferredPushTokenSyncer: PushTokenSyncing {
    private var lastObservedToken: String?

    func sync(fcmToken: String) async {
        guard lastObservedToken != fcmToken else { return }

        lastObservedToken = fcmToken
        Logger.shared.info(
            "FCM 토큰 수신됨. 서버 등록 API 연결 대기",
            category: .general
        )
    }
}
