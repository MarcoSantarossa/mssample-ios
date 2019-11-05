@testable import Album

import XCTest

final class AlbumInteractorTests: XCTestCase {

    private var sut: AlbumInteractor!
    private var repo: SpyAlbumRepository!

    override func setUp() {
        super.setUp()

        repo = SpyAlbumRepository()
        sut = AlbumInteractor(dependencies: .init(repo: repo))
    }

    override func tearDown() {
        repo = nil
        sut = nil

        super.tearDown()
    }
}

// MARK: - getAlbum
extension AlbumInteractorTests {
    func test_getAlbum_callsRepo() {
        sut.getAlbum { _ in }

        XCTAssertEqual(repo.getAlbumCallsCount, 1)
    }

    func test_getAlbum_completionIsCalled() {
        var completionCallsCount = 0

        sut.getAlbum { _ in completionCallsCount += 1 }

        XCTAssertEqual(completionCallsCount, 1)
    }

    func test_getAlbum_repoCompletionArgNil_completionArgNil() {
        var completionArg: Album?

        sut.getAlbum { completionArg = $0 }

        XCTAssertNil(completionArg)
    }

    func test_getAlbum_repoCompletionArg_completionArg() {
        let forcedAlbum = Album(id: 1, title: "a1", photos: [])
        repo.getAlbumForcedResult = forcedAlbum
        var completionArg: Album?

        sut.getAlbum { completionArg = $0 }

        XCTAssertEqual(completionArg!, forcedAlbum)
    }
}

// MARK: - getPhoto
extension AlbumInteractorTests {
    func test_getPhoto_callsRepo() {
        sut.getPhoto(id: 10) { _ in }

        XCTAssertEqual(repo.getPhotoCallsCount, 1)
    }

    func test_getPhoto_completionIsCalled() {
        var completionCallsCount = 0

        sut.getPhoto(id: 10) { _ in completionCallsCount += 1 }

        XCTAssertEqual(completionCallsCount, 1)
    }

    func test_getPhoto_repoCompletionArgNil_completionArgNil() {
        var completionArg: Photo?

        sut.getPhoto(id: 10) { completionArg = $0 }

        XCTAssertNil(completionArg)
    }

    func test_getPhoto_repoCompletionArg_completionArg() {
        let forcedPhoto = Photo(id: 1, title: "t1", url: "u1", thumbnailUrl: "tu1")
        repo.getPhotoForcedResult = forcedPhoto
        var completionArg: Photo?

        sut.getPhoto(id: 10) { completionArg = $0 }

        XCTAssertEqual(completionArg!, forcedPhoto)
    }
}
