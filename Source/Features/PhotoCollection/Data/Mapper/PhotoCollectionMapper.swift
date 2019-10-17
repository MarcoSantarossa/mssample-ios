protocol PhotoCollectionMapperProtocol: AnyObject {
    func map(dtos: [PhotoCollectionItemDTO]) -> [PhotoCollectionItem]
}

final class PhotoCollectionMapper: PhotoCollectionMapperProtocol {
    func map(dtos: [PhotoCollectionItemDTO]) -> [PhotoCollectionItem] {
        return dtos.map {
            PhotoCollectionItem(id: $0.id, title: $0.title, thumbnailUrl: $0.thumbnailUrl)
        }
    }
}
