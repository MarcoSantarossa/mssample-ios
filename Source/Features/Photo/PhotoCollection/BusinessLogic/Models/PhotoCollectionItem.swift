struct PhotoCollectionItem {
    let id: Int
    let title: String
    let thumbnailUrl: String
}

extension PhotoCollectionItem: Equatable {
    static func == (lhs: PhotoCollectionItem, rhs: PhotoCollectionItem) -> Bool {
        return lhs.id == rhs.id
            && lhs.title == rhs.title
            && lhs.thumbnailUrl == rhs.thumbnailUrl
    }
}
