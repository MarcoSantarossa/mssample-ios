@testable import Album

final class SpyAlbumRepository: AlbumRepositoryProtocol {

    private(set) var getAlbumCallsCount = 0
    var getAlbumForcedResult: Album?

    func getAlbum(completion: @escaping (Album?) -> Void) {
        getAlbumCallsCount += 1

        completion(getAlbumForcedResult)
    }
}
