final class PhotoCollectionItemDTO: Decodable {
    let id: Int
    let title: String
    let thumbnailUrl: String

    init(id: Int, title: String, thumbnailUrl: String) {
        self.id = id
        self.title = title
        self.thumbnailUrl = thumbnailUrl
    }
}
