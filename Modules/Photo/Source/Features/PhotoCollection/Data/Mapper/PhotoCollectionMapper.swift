protocol PhotoCollectionMapperProtocol: AnyObject {
    func map(dtos: [PhotoCollectionItemDTO]) -> [PhotoCollectionItem]
}

final class PhotoCollectionMapper: PhotoCollectionMapperProtocol {
    func map(dtos: [PhotoCollectionItemDTO]) -> [PhotoCollectionItem] {
        return dtos.map {
            PhotoCollectionItem(id: $0.id, title: String($0.title.split(separator: " ")[0]).capitalized, thumbnailUrl: $0.thumbnailUrl)
        }
    }
}
