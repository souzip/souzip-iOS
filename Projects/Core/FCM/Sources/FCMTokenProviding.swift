import Foundation

public protocol FCMTokenProviding: AnyObject {
    func currentToken() async -> String?

    /// 토큰 갱신 스트림. 구독 시점에 이미 토큰이 있으면 즉시 한 번 방출한다.
    func fcmTokenUpdates() -> AsyncStream<String>

    func configure()
    func setAPNSToken(_ deviceToken: Data)
}
