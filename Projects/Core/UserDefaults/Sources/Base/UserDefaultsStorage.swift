import Foundation
import Utils

public protocol UserDefaultsStorage: AnyObject {
    func get<Value>(_ key: DefaultsKey<Value>) -> Value
    func set<Value>(_ value: Value, for key: DefaultsKey<Value>)
    func remove<Value>(_ key: DefaultsKey<Value>)

    func getDecodable<T: Decodable>(from key: DefaultsKey<Data?>) throws -> T?
    func setEncodable<T: Encodable>(_ value: T, for key: DefaultsKey<Data?>) throws
}

public final class DefaultUDStorage: UserDefaultsStorage {
    private let userDefaults: UserDefaults

    public init(_ userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    public func get<Value>(_ key: DefaultsKey<Value>) -> Value {
        (userDefaults.object(forKey: key.name) as? Value) ?? key.defaultValue
    }

    public func set<Value>(_ value: Value, for key: DefaultsKey<Value>) {
        userDefaults.set(value, forKey: key.name)
    }

    public func remove(_ key: DefaultsKey<some Any>) {
        userDefaults.removeObject(forKey: key.name)
    }

    public func getDecodable<T: Decodable>(from key: DefaultsKey<Data?>) throws -> T? {
        guard let data = userDefaults.data(forKey: key.name) else {
            return nil
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw UserDefaultsError.decodingFailed(key: key.name, error: error)
        }
    }

    public func setEncodable(_ value: some Encodable, for key: DefaultsKey<Data?>) throws {
        do {
            let data = try JSONEncoder().encode(value)
            userDefaults.set(data, forKey: key.name)
        } catch {
            throw UserDefaultsError.encodingFailed(key: key.name, error: error)
        }
    }
}
