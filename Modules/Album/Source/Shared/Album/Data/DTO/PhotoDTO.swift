final class PhotoDTO: Decodable {
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String

    init(id: Int, title: String, url: String, thumbnailUrl: String) {
        self.id = id
        self.title = title
        self.url = url
        self.thumbnailUrl = thumbnailUrl
    }
}
