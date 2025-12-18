import Foundation
import Utils

public protocol UserDefaultsStorage: AnyObject {
    func get<Value>(_ key: DefaultsKey<Value>) -> Value
    func set<Value>(_ value: Value, for key: DefaultsKey<Value>)
    func remove<Value>(_ key: DefaultsKey<Value>)

    func getCodable<Value: Codable>(_ key: DefaultsKey<Value>) -> Value
    func setCodable<Value: Codable>(_ value: Value, for key: DefaultsKey<Value>)
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

    public func getCodable<Value: Codable>(_ key: DefaultsKey<Value>) -> Value {
        guard let data = userDefaults.data(forKey: key.name) else { return key.defaultValue }
        return (try? JSONDecoder().decode(Value.self, from: data)) ?? key.defaultValue
    }

    public func setCodable<Value: Codable>(_ value: Value, for key: DefaultsKey<Value>) {
        guard let data = try? JSONEncoder().encode(value) else { return }
        userDefaults.set(data, forKey: key.name)
    }
}
