@testable import Album

import XCTest

final class PhotoCollectionMapperTests: XCTestCase {

    private var sut: PhotoCollectionMapper!

    override func setUp() {
        super.setUp()

        sut = PhotoCollectionMapper()
    }

    override func tearDown() {
        sut = nil

        super.tearDown()
    }
}

// MARK: map
extension PhotoCollectionMapperTests {
    func test_map_returnsCorrectModels() {
        let dtos: [PhotoCollectionItemDTO] = [
            .init(id: 1, title: "t1", thumbnailUrl: "th1"),
            .init(id: 2, title: "t2 232 rrr", thumbnailUrl: "th2"),
            .init(id: 3, title: "t3 ", thumbnailUrl: "th3")
        ]

        let result = sut.map(dtos: dtos)

        XCTAssertEqual(
            result,
            [
                PhotoCollectionItem(id: 1, title: "T1", thumbnailUrl: "th1"),
                PhotoCollectionItem(id: 2, title: "T2", thumbnailUrl: "th2"),
                PhotoCollectionItem(id: 3, title: "T3", thumbnailUrl: "th3")
            ]
        )
    }
}
