@testable import Album

import XCTest

final class AlbumMapperTests: XCTestCase {

    private var sut: AlbumMapper!

    override func setUp() {
        super.setUp()

        sut = AlbumMapper()
    }

    override func tearDown() {
        sut = nil

        super.tearDown()
    }

    private func createAlbumDTO() -> AlbumDTO {
        return .init(id: 1, title: "album test")
    }

    private func createPhotoDTOs(count: Int) -> [PhotoDTO] {
        return Array(1...count).map {
            return PhotoDTO(id: $0, title: "photo \($0)", url: "photo url \($0)", thumbnailUrl: "thumb photo url \($0)")
        }
    }
}

// MARK: - map
extension AlbumMapperTests {
    func test_map_emptyPhotos_retunsAlbumWithoutPhotos() {
        let result = sut.map(albumDTO: createAlbumDTO(), photoDTOs: [])

        XCTAssertEqual(result.id, 1)
        XCTAssertEqual(result.title, "album test")
        XCTAssertEqual(result.photos.count, 0)
    }

    func test_map_withPhotos_retunsAlbumWithPhotos() {
        let result = sut.map(albumDTO: createAlbumDTO(), photoDTOs: createPhotoDTOs(count: 2))

        XCTAssertEqual(result.id, 1)
        XCTAssertEqual(result.title, "album test")
        XCTAssertEqual(result.photos.count, 2)
        XCTAssertEqual(result.photos[0].id, 1)
        XCTAssertEqual(result.photos[0].title, "photo 1")
        XCTAssertEqual(result.photos[0].url, "photo url 1")
        XCTAssertEqual(result.photos[0].thumbnailUrl, "thumb photo url 1")
        XCTAssertEqual(result.photos[1].id, 2)
        XCTAssertEqual(result.photos[1].title, "photo 2")
        XCTAssertEqual(result.photos[1].url, "photo url 2")
        XCTAssertEqual(result.photos[1].thumbnailUrl, "thumb photo url 2")
    }
}
