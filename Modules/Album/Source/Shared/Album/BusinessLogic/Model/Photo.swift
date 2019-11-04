struct Photo {
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
}

extension Photo: Equatable {
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.id == rhs.id
            && lhs.title == rhs.title
            && lhs.url == rhs.url
            && lhs.thumbnailUrl == rhs.thumbnailUrl
    }
}
