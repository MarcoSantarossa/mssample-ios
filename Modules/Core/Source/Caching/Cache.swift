public protocol CacheProtocol: AnyObject {
    associatedtype Key
    associatedtype Value

    func get(key: Key) -> Value?

    func set(value: Value, key: Key)
}

public class Cache<Key: AnyObject, Value: AnyObject>: CacheProtocol {

    private let cache = NSCache<Key, Value>()

    public init() {}

    public func get(key: Key) -> Value? {
        return cache.object(forKey: key)
    }

    public func set(value: Value, key: Key) {
        cache.setObject(value, forKey: key)
    }
}
