public protocol LocalizerProtocol: AnyObject {
    func localize(_ value: String, tableName: String?, bundle: Bundle) -> String
}

public final class Localizer: LocalizerProtocol {
    public init() { }

    public func localize(_ string: String, tableName: String?, bundle: Bundle) -> String {
        return NSLocalizedString(string, tableName: tableName, bundle: bundle, value: "**\(string)**", comment: "")
    }
}
