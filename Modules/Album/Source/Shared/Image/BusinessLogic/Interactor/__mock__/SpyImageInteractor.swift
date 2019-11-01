@testable import Album

final class SpyImageInteractor: ImageInteractorProtocol {

    static var shared: SpyImageInteractor!

    private(set) var getImageCallsCount = 0
    private(set) var getImageUrlArg: String!
    static var forcedGetImage: Image?

    private(set) var cancelCallsCount = 0

    init() {
        SpyImageInteractor.shared = self
    }

    func getImage(at url: String, completion: @escaping (Image) -> Void) {
        getImageCallsCount += 1
        getImageUrlArg = url

        if let forcedGetImage = SpyImageInteractor.forcedGetImage {
            completion(forcedGetImage)
        }
    }

    func cancel() {
        cancelCallsCount += 1
    }

    static func clean() {
        forcedGetImage = nil
        shared = nil
    }
}
