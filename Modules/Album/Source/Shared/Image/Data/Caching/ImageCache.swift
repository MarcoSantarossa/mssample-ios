import Core

protocol ImageCacheProtocol: AnyObject {
    func getImageData(key: String) -> Image?
    func setImageData(value: Image, key: String)
}

extension Cache: ImageCacheProtocol where Cache.Key == NSString, Cache.Value == Image {
    func getImageData(key: String) -> Image? {
        return self.get(key: (key as NSString))
    }

    func setImageData(value: Image, key: String) {
        self.set(value: value, key: (key as NSString))
    }
}
