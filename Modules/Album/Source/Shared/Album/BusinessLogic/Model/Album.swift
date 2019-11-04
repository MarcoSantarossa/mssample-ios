struct Album {
    let id: Int
    let title: String
    let photos: [Photo]
}

extension Album: Equatable {
    static func == (lhs: Album, rhs: Album) -> Bool {
        return lhs.id == rhs.id
            && lhs.title == rhs.title
            && lhs.photos == rhs.photos
    }
}
