public protocol FCMFactory: AnyObject {
    func makeFCMTokenProvider() -> FCMTokenProviding
}

public final class DefaultFCMFactory: FCMFactory {
    public static let shared = DefaultFCMFactory()

    private init() {}

    public func makeFCMTokenProvider() -> FCMTokenProviding {
        FCMManager.shared
    }
}
