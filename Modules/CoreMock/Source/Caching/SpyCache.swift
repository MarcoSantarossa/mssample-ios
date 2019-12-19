import Core

public final class SpyCache<Key: AnyObject, Value: AnyObject>: CacheProtocol {

    public private(set) var getCallsCount = 0
    public var getKeyArg: Key!
    public var forcedGetValue: Value?

    public private(set) var setCallsCount = 0
    public var setKeyArg: Key!
    public var setValueArg: Value?

    public init() {}

    public func get(key: Key) -> Value? {
        getCallsCount += 1
        getKeyArg = key

        return forcedGetValue
    }

    public func set(value: Value, key: Key) {
        setCallsCount += 1
        setKeyArg = key
        setValueArg = value
    }
}
