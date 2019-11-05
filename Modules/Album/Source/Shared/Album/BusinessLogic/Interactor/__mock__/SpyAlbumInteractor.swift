@testable import Album

final class SpyAlbumInteractor: AlbumInteractorProtocol {
    private(set) var getAlbumCallsCount = 0
    var getAlbumForcedResult: Album?

    private(set) var getPhotoCallsCount = 0
    private(set) var getPhotoIdArg: Int!
    var getPhotoForcedResult: Photo?

    func getAlbum(completion: @escaping (Album?) -> Void) {
        getAlbumCallsCount += 1

        completion(getAlbumForcedResult)
    }

    func getPhoto(id: Int, completion: @escaping (Photo?) -> Void) {
        getPhotoCallsCount += 1
        getPhotoIdArg = id

        completion(getPhotoForcedResult)
    }
}
