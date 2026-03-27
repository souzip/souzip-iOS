public protocol UserDefaultsFactory: AnyObject {
    func makeUDStorage() -> UserDefaultsStorage
}

public final class DefaultsUDFactory: UserDefaultsFactory {
    public init() {}

    public func makeUDStorage() -> UserDefaultsStorage {
        DefaultUDStorage()
    }
}
