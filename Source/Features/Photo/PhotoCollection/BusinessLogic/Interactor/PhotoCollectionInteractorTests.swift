@testable import MSSampleiOS

import XCTest

final class PhotoCollectionInteractorTests: XCTestCase {

    private var sut: PhotoCollectionInteractor!
    private var repo: SpyPhotoCollectionRepository!

    override func setUp() {
        super.setUp()

        repo = SpyPhotoCollectionRepository()
        sut = PhotoCollectionInteractor(dependencies: .init(repo: repo))
    }

    override func tearDown() {
        repo = nil
        sut = nil

        super.tearDown()
    }
}

// MARK: - getPhotos
extension PhotoCollectionInteractorTests {
    func test_getPhotos_callsRepo() {
        sut.getPhotos { _ in }

        XCTAssertEqual(repo.getPhotosCallsCount, 1)
    }

    func test_getPhotos_completionReturnsRepoItems() {
        repo.forcedGetPhotosItemsArg = [.init(id: 1, title: "t1", thumbnailUrl: "th1")]
        var arg: [PhotoCollectionItem]!

        sut.getPhotos { arg = $0 }

        XCTAssertEqual(arg, repo.forcedGetPhotosItemsArg)
    }

}
