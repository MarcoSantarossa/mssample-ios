import Foundation

final class Image {
    let id: String
    let data: Data

    init(id: String, data: Data) {
        self.id = id
        self.data = data
    }
}
