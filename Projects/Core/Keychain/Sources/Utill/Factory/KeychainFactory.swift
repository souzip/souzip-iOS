public protocol KeychainFactory: AnyObject {
    func makeKeychainStorage() -> KeychainStorage
}

public final class DefaultKeychainFactory: KeychainFactory {
    private let bundleID: String

    public init(bundleID: String) {
        self.bundleID = bundleID
    }

    public func makeKeychainStorage() -> KeychainStorage {
        DefaultKeychainStorage(service: bundleID)
    }
}
