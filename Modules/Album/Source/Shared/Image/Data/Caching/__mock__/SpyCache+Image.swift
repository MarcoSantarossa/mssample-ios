@testable import Album

import CoreMock

extension SpyCache: ImageCacheProtocol where SpyCache.Key == NSString, SpyCache.Value == Image {
    public func getImageData(key: String) -> Image? {
        return self.get(key: (key as NSString))
    }

    public func setImageData(value: Image, key: String) {
        self.set(value: value, key: (key as NSString))
    }
}
