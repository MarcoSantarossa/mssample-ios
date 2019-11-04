@testable import Album

final class SpyImageRepository: ImageRepositoryProtocol {

    private(set) var getImageCallsCount = 0
    private(set) var getImageUrlArg: String!
    var forcedGetImage: Image?

    private(set) var cancelCallsCount = 0

    func getImage(at url: String, completion: @escaping (Image) -> Void) {
        getImageCallsCount += 1
        getImageUrlArg = url

        if let forcedGetImage = forcedGetImage {
            completion(forcedGetImage)
        }
    }

    func cancel() {
        cancelCallsCount += 1
    }
}
