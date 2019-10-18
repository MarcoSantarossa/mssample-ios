@testable import MSSampleiOS

import XCTest

final class PhotoCollectionPresenterTests: XCTestCase {

    private var sut: PhotoCollectionPresenter!
    private var interactor: SpyPhotoCollectionInteractor!

    override func setUp() {
        super.setUp()

        interactor = SpyPhotoCollectionInteractor()
        sut = PhotoCollectionPresenter(dependencies: .init(interactor: interactor))
    }

    override func tearDown() {
        sut = nil
        interactor = nil

        super.tearDown()
    }

    private func loadItems() {
        interactor.forcedGetPhotosItemsArg = [
            .init(id: 1, title: "t1", thumbnailUrl: "th1"),
            .init(id: 2, title: "t2", thumbnailUrl: "th2"),
            .init(id: 3, title: "t3", thumbnailUrl: "th3")
        ]
        sut.viewDidLoad()
    }
}

// MARK: - viewDidLoad
extension PhotoCollectionPresenterTests {
    func test_viewDidLoad_callsInteractor() {
        sut.viewDidLoad()

        XCTAssertEqual(interactor.getPhotosCallsCount, 1)
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

// MARK: - title(at:)
extension PhotoCollectionPresenterTests {
    func test_title_invalidIndex_returnsEmpty() {
        let result = sut.title(at: 10)

        XCTAssertEqual(result, "")
    }

    func test_title_validIndex_returnsValidTitle() {
        loadItems()

        let result = sut.title(at: 1)

        XCTAssertEqual(result, "t2")
    }
}
