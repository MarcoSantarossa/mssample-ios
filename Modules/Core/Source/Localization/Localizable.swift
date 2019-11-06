public protocol Localizable {
    associatedtype LocalizableKey

    static var tableName: String? { get }
    static var bundle: Bundle { get }

    static func localize(key: LocalizableKey, localizer: LocalizerProtocol) -> String
}

extension Localizable where LocalizableKey: RawRepresentable {
    public static var tableName: String? {
        return String(describing: Self.self)
    }

    public static func localize(key: LocalizableKey, localizer: LocalizerProtocol = Localizer()) -> String {
        return localizer.localize("\(key.rawValue)", tableName: self.tableName, bundle: self.bundle)
    }
}
