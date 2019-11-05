protocol AlbumMapperProtocol: AnyObject {
    func map(albumDTO: AlbumDTO, photoDTOs: [PhotoDTO]) -> Album
    func map(photoDTO: PhotoDTO) -> Photo
}

final class AlbumMapper: AlbumMapperProtocol {
    func map(albumDTO: AlbumDTO, photoDTOs: [PhotoDTO]) -> Album {
        let photos = photoDTOs.map {
            return Photo(id: $0.id, title: $0.title, url: $0.url, thumbnailUrl: $0.thumbnailUrl)
        }
        return Album(id: albumDTO.id, title: albumDTO.title, photos: photos)
    }

    func map(photoDTO: PhotoDTO) -> Photo {
        return Photo(id: photoDTO.id, title: photoDTO.title, url: photoDTO.url, thumbnailUrl: photoDTO.thumbnailUrl)
    }
}
