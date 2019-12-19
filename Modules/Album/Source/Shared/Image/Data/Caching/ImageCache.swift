import Core

public protocol ImageCacheProtocol: AnyObject {
    func getImageData(key: String) -> Data?
    func setImageData(value: Data, key: String)
}

extension Cache: ImageCacheProtocol where Cache.Key == NSString, Cache.Value == NSData {
    public func getImageData(key: String) -> Data? {
        return self.get(key: (key as NSString)) as Data?
    }

    public func setImageData(value: Data, key: String) {
        self.set(value: (value as NSData), key: (key as NSString))
    }
}
