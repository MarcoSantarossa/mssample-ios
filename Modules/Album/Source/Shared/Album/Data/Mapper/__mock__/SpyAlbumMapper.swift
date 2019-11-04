@testable import Album

final class SpyAlbumMapper: AlbumMapperProtocol {

    private(set) var mapCallsCount = 0
    private(set) var mapAlbumDTOArg: AlbumDTO!
    private(set) var mapPhotoDTOs: [PhotoDTO]!
    var forcedMapResult: Album!

    func map(albumDTO: AlbumDTO, photoDTOs: [PhotoDTO]) -> Album {
        mapCallsCount += 1
        mapAlbumDTOArg = albumDTO
        mapPhotoDTOs = photoDTOs

        return forcedMapResult
    }
}
