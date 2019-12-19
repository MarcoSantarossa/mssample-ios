import Core

final class AlbumEnvironment {

    static let shared = AlbumEnvironment()

    private(set) lazy var imageCache: ImageCacheProtocol = Cache<NSString, Image>()
}
