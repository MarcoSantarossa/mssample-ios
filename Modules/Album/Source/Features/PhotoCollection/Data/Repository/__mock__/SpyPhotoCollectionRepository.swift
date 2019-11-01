@testable import Album

final class SpyPhotoCollectionRepository: PhotoCollectionRepositoryProtocol {

    private(set) var getPhotosCallsCount = 0
    var forcedGetPhotosItemsArg: [PhotoCollectionItem]?

    func getPhotos(completion: @escaping ([PhotoCollectionItem]) -> Void) {
        getPhotosCallsCount += 1

        if let forcedGetPhotosItemsArg = forcedGetPhotosItemsArg {
            completion(forcedGetPhotosItemsArg)
        }
    }
}
