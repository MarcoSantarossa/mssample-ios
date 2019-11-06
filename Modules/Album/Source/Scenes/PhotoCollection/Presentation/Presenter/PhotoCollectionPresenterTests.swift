@testable import Album

import CoreMock
import XCTest

final class PhotoCollectionPresenterTests: XCTestCase {

    private var sut: PhotoCollectionPresenter!
    private var interactor: SpyAlbumInteractor!
    private var imageInteractors = [String: SpyImageInteractor]()

    override func setUp() {
        super.setUp()

        interactor = SpyAlbumInteractor()
        sut = PhotoCollectionPresenter(dependencies: .init(interactor: interactor, imageInteractorType: SpyImageInteractor.self))
    }

    override func tearDown() {
        sut = nil
        interactor = nil

        SpyImageInteractor.clean()

        super.tearDown()
    }

    private func loadItems() {
        interactor.getAlbumForcedResult = Album(id: 10, title: "a1", photos: [
            Photo(id: 1, title: "ph 1", url: "url 1", thumbnailUrl: "th url 1"),
            Photo(id: 2, title: "ph 2", url: "url 2", thumbnailUrl: "th url 2"),
            Photo(id: 3, title: "ph 3", url: "url 3", thumbnailUrl: "th url 3")

            ])
        sut.viewDidLoad()
    }
}

// MARK: - state
extension PhotoCollectionPresenterTests {
    func test_state_default_returnsLoading() {
        let result = sut.state

        XCTAssertEqual(result, .loading)
    }

    func test_state_loadAlbumNil_returnsDataNotFound() {
        interactor.getAlbumForcedResult = nil
        sut.viewDidLoad()

        let result = sut.state

        XCTAssertEqual(result, .dataNotFound)
    }

    func test_state_loadAlbum_returnsDataAvailable() {
        loadItems()

        let result = sut.state

        XCTAssertEqual(result, .dataAvailable)
    }
}

// MARK: - albumTitle
extension PhotoCollectionPresenterTests {
    func test_albumTitle_beforeLoadingItems_returnsEmptyText() {
        let result = sut.albumTitle

        XCTAssertEqual(result, "")
    }

    func test_albumTitle_afterLoadingItems_returnsExpectedValue() {
        loadItems()

        let result = sut.albumTitle

        XCTAssertEqual(result, "a1")
    }
}

// MARK: - viewDidLoad
extension PhotoCollectionPresenterTests {
    func test_viewDidLoad_callsInteractor() {
        sut.viewDidLoad()

        XCTAssertEqual(interactor.getAlbumCallsCount, 1)
    }
}

// MARK: - itemsCount
extension PhotoCollectionPresenterTests {
    func test_itemsCount_beforeLoadingItems_returnsZero() {
        let result = sut.itemsCount

        XCTAssertEqual(result, 0)
    }

    func test_itemsCount_afterLoadingItems_returnsRightNumber() {
        loadItems()

        let result = sut.itemsCount

        XCTAssertEqual(result, 3)
    }
}

// MARK: - onDataDidUpdate
extension PhotoCollectionPresenterTests {
    func test_onDataDidUpdate_beforeLoadingItems_isNotCalled() {
        var onDataDidUpdateCallsCount = 0
        sut = PhotoCollectionPresenter(dependencies: .init(interactor: interactor))

        sut.onDataDidUpdate = {
            onDataDidUpdateCallsCount += 1
        }

        XCTAssertEqual(onDataDidUpdateCallsCount, 0)
    }

    func test_onDataDidUpdate_afterLoadingItems_isNotCalled() {
        var onDataDidUpdateCallsCount = 0
        sut = PhotoCollectionPresenter(dependencies: .init(interactor: interactor))
        sut.onDataDidUpdate = {
            onDataDidUpdateCallsCount += 1
        }
        loadItems()

        XCTAssertEqual(onDataDidUpdateCallsCount, 1)
    }
}

// MARK: - title
extension PhotoCollectionPresenterTests {
    func test_title_invalidIndex_returnsEmpty() {
        let result = sut.title(at: 10)

        XCTAssertEqual(result, "")
    }

    func test_title_validIndex_returnsValidTitle() {
        loadItems()

        let result = sut.title(at: 1)

        XCTAssertEqual(result, "Ph 2")
    }
}

// MARK: - startLoadImage
extension PhotoCollectionPresenterTests {
    func test_startLoadImage_invalidIndex_doesNotCreateImageInteractor() {
        sut.startLoadImage(at: 10) { _ in }

        XCTAssertNil(SpyImageInteractor.shared)
    }

    func test_startLoadImage_validIndex_createsImageInteractor() {
        loadItems()

        sut.startLoadImage(at: 1) { _ in }

        XCTAssertNotNil(SpyImageInteractor.shared)
    }

    func test_startLoadImage_validIndex_callsInteractor() {
        loadItems()

        sut.startLoadImage(at: 1) { _ in }

        XCTAssertEqual(SpyImageInteractor.shared.getImageCallsCount, 1)
    }

    func test_startLoadImage_validIndex_callsInteractorWithRightArg() {
        loadItems()

        sut.startLoadImage(at: 1) { _ in }

        XCTAssertEqual(SpyImageInteractor.shared.getImageUrlArg, "th url 2")
    }

    func test_startLoadImage_completionUsesInteractorImage() {
        let data = "data test".data(using: .utf8)!
        SpyImageInteractor.forcedGetImage = Image(id: "1", data: data)
        var arg: Data!
        loadItems()

        sut.startLoadImage(at: 1) { arg = $0 }

        XCTAssertEqual(arg, data)
    }

    func test_startLoadImage_calledTwiceSameIndex_skipSecondImageInteractor() {
        loadItems()

        sut.startLoadImage(at: 1) { _ in }
        let currentImageInteractor = SpyImageInteractor.shared
        sut.startLoadImage(at: 1) { _ in }

        XCTAssertTrue(currentImageInteractor === SpyImageInteractor.shared)
        XCTAssertEqual(currentImageInteractor?.getImageCallsCount, 1)
    }

    func test_startLoadImage_calledTwiceDifferentIndex_createsImageInteractorTwice() {
        loadItems()

        sut.startLoadImage(at: 1) { _ in }
        let currentImageInteractor = SpyImageInteractor.shared
        sut.startLoadImage(at: 2) { _ in }

        XCTAssertTrue(currentImageInteractor !== SpyImageInteractor.shared)
    }

    func test_startLoadImage_calledTwiceDifferentIndex_callsImageInteractorTwice() {
        loadItems()

        sut.startLoadImage(at: 1) { _ in }
        let currentImageInteractor = SpyImageInteractor.shared
        sut.startLoadImage(at: 2) { _ in }

        XCTAssertEqual(currentImageInteractor?.getImageCallsCount, 1)
        XCTAssertEqual(SpyImageInteractor.shared.getImageCallsCount, 1)
    }
}

// MARK: - cancelLoadImage
extension PhotoCollectionPresenterTests {
    func test_cancelLoadImage_invalidIndex_doesNotCallInteractor() {
        loadItems()
        sut.startLoadImage(at: 1) { _ in }

        sut.cancelLoadImage(at: 10)

        XCTAssertEqual(SpyImageInteractor.shared.cancelCallsCount, 0)
    }

    func test_cancelLoadImage_validIndex_callsInteractor() {
        loadItems()
        sut.startLoadImage(at: 1) { _ in }

        sut.cancelLoadImage(at: 1)

        XCTAssertEqual(SpyImageInteractor.shared.cancelCallsCount, 1)
    }

    func test_cancelLoadImage_calledTwice_callsInteractorOnce() {
        loadItems()
        sut.startLoadImage(at: 1) { _ in }

        sut.cancelLoadImage(at: 1)
        sut.cancelLoadImage(at: 1)

        XCTAssertEqual(SpyImageInteractor.shared.cancelCallsCount, 1)
    }
}

// MARK: - photoId
extension PhotoCollectionPresenterTests {
    func test_photoId_beforeLoadingPhotos_returnsInvalidId() {
        let result = sut.photoId(at: 10)

        XCTAssertEqual(result, -1)
    }

    func test_photoId_loadPhotosAndInvalidIndex_returnsInvalidId() {
        loadItems()

        let result = sut.photoId(at: 10)

        XCTAssertEqual(result, -1)
    }

    func test_photoId_loadPhotosAndValidIndex_returnsValidId() {
        loadItems()

        let result = sut.photoId(at: 1)

        XCTAssertEqual(result, 2)
    }
}
