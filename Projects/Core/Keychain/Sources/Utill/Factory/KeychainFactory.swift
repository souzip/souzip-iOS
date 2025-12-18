public protocol KeychainFactory: AnyObject {
    func makeKeychainStorge() -> KeychainStorage
}

public final class DefaultKeychainFactory: KeychainFactory {
    private let bundleID: String

    public init(bundleID: String) {
        self.bundleID = bundleID
    }

    public func makeKeychainStorge() -> KeychainStorage {
        DefaultKeychainStorage(service: bundleID)
    }
}
