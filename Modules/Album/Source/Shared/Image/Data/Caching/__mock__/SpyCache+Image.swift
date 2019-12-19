@testable import Album

import CoreMock

extension SpyCache: ImageCacheProtocol where SpyCache.Key == NSString, SpyCache.Value == NSData {
    public func getImageData(key: String) -> Data? {
        return self.get(key: (key as NSString)) as Data?
    }

    public func setImageData(value: Data, key: String) {
        self.set(value: (value as NSData), key: (key as NSString))
    }
}
