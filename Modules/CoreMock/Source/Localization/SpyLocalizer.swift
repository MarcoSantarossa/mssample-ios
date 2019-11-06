import Core

public final class SpyLocalizer: LocalizerProtocol {

    public private(set) var localizeCallsCount = 0
    public private(set) var localizeValueArg: String!
    public private(set) var localizeTableNameArg: String!
    public var localizeForcedResult: String!

    public init() {}

    public func localize(_ value: String, tableName: String?, bundle: Bundle) -> String {
        localizeCallsCount += 1
        localizeValueArg = value
        localizeTableNameArg = tableName

        return localizeForcedResult
    }
}
