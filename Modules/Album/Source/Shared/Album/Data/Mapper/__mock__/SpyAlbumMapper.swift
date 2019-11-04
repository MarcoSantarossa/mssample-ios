@testable import Album

final class SpyAlbumMapper: AlbumMapperProtocol {

    private(set) var mapCallsCount = 0
    private(set) var mapAlbumDTOArg: AlbumDTO!
    private(set) var mapPhotoDTOs: [PhotoDTO]!
    var forcedMapResult: Album!

    private(set) var mapPhotoCallsCount = 0
    private(set) var mapPhotoDTOArg: PhotoDTO!
    var forcedMapPhotoResult: Photo!

    func map(albumDTO: AlbumDTO, photoDTOs: [PhotoDTO]) -> Album {
        mapCallsCount += 1
        mapAlbumDTOArg = albumDTO
        mapPhotoDTOs = photoDTOs

        return forcedMapResult
    }

    func map(photoDTO: PhotoDTO) -> Photo {
        mapPhotoCallsCount += 1
        mapPhotoDTOArg = photoDTO

        return forcedMapPhotoResult
    }


}
