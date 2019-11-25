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

    func test_viewDidLoad_LoadItemsNil_callsOnStateDidChange() {
        var onStateDidChangeCallsCount = 0
        sut.onStateDidChange = { _ in
            onStateDidChangeCallsCount += 1
        }
        interactor.getAlbumForcedResult = nil

        sut.viewDidLoad()

        XCTAssertEqual(onStateDidChangeCallsCount, 1)
    }

    func test_viewDidLoad_LoadItemsNil_callsOnStateDidChangeWithRightArg() {
        var onStateDidChangeArg: PhotoCollectionPresenterState!
        sut = PhotoCollectionPresenter(dependencies: .init(interactor: interactor))
        sut.onStateDidChange = { onStateDidChangeArg = $0 }
        interactor.getAlbumForcedResult = nil

        sut.viewDidLoad()

        XCTAssertEqual(onStateDidChangeArg, .dataNotFound)
    }

    func test_viewDidLoad_LoadItems_callsOnStateDidChange() {
        var onStateDidChangeCallsCount = 0
        sut.onStateDidChange = { _ in
            onStateDidChangeCallsCount += 1
        }
        interactor.getAlbumForcedResult = Album(id: 10, title: "a1", photos: [
            Photo(id: 1, title: "ph 1", url: "url 1", thumbnailUrl: "th url 1"),
            Photo(id: 2, title: "ph 2", url: "url 2", thumbnailUrl: "th url 2"),
            Photo(id: 3, title: "ph 3", url: "url 3", thumbnailUrl: "th url 3")

            ])

        sut.viewDidLoad()

        XCTAssertEqual(onStateDidChangeCallsCount, 1)
    }

    func test_viewDidLoad_LoadItems_callsOnStateDidChangeWithRightArg() {
        var onStateDidChangeArg: PhotoCollectionPresenterState!
        sut = PhotoCollectionPresenter(dependencies: .init(interactor: interactor))
        sut.onStateDidChange = { onStateDidChangeArg = $0 }
        interactor.getAlbumForcedResult = Album(id: 10, title: "a1", photos: [
            Photo(id: 1, title: "ph 1", url: "url 1", thumbnailUrl: "th url 1"),
            Photo(id: 2, title: "ph 2", url: "url 2", thumbnailUrl: "th url 2"),
            Photo(id: 3, title: "ph 3", url: "url 3", thumbnailUrl: "th url 3")

            ])

        sut.viewDidLoad()

        XCTAssertEqual(onStateDidChangeArg, .dataAvailable)
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

// MARK: - onStateDidChange
extension PhotoCollectionPresenterTests {
    func test_onStateDidChange_beforeLoadingItems_isNotCalled() {
        var onStateDidChangeCallsCount = 0
        sut = PhotoCollectionPresenter(dependencies: .init(interactor: interactor))

        sut.onStateDidChange = { _ in
            onStateDidChangeCallsCount += 1
        }

        XCTAssertEqual(onStateDidChangeCallsCount, 0)
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

// MARK: - itemDidShow
extension PhotoCollectionPresenterTests {
    func test_itemDidShow_invalidIndex_doesntCallClosure() {
        var closureCallsCount = 0
        sut.onImageDidLoad = { _, _ in
            closureCallsCount += 1
        }

        sut.itemDidShow(at: 10)

        XCTAssertEqual(closureCallsCount, 0)
    }

    func test_itemDidShow_validIndex_callsClosure() {
        let data = "data test".data(using: .utf8)!
        SpyImageInteractor.forcedGetImage = Image(id: "1", data: data)
        loadItems()
        var closureCallsCount = 0
        sut.onImageDidLoad = { _, _ in
            closureCallsCount += 1
        }

        sut.itemDidShow(at: 1)

        XCTAssertEqual(closureCallsCount, 1)
    }

    func test_itemDidShow_validIndex_callsClosureWithRightArgs() {
        let dataInput = "data test".data(using: .utf8)!
        SpyImageInteractor.forcedGetImage = Image(id: "1", data: dataInput)
        loadItems()
        var indexArg: Int!
        var dataArg: Data!
        sut.onImageDidLoad = {
            indexArg = $0
            dataArg = $1
        }

        sut.itemDidShow(at: 1)

        XCTAssertEqual(indexArg, 1)
        XCTAssertEqual(dataArg, dataInput)
    }
}

// MARK: - itemDidHide
extension PhotoCollectionPresenterTests {
    func test_itemDidHide_validIndex_cancelRequest() {
        loadItems()
        sut.itemDidShow(at: 1)

        sut.itemDidHide(at: 1)

        XCTAssertEqual(SpyImageInteractor.shared.cancelCallsCount, 1)
    }
}
