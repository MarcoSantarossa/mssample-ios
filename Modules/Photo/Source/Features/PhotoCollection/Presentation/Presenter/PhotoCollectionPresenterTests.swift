@testable import Photo

import XCTest

final class PhotoCollectionPresenterTests: XCTestCase {

    private var sut: PhotoCollectionPresenter!
    private var interactor: SpyPhotoCollectionInteractor!
    private var imageInteractors = [String: SpyImageInteractor]()

    override func setUp() {
        super.setUp()

        interactor = SpyPhotoCollectionInteractor()
        sut = PhotoCollectionPresenter(dependencies: .init(interactor: interactor, imageInteractorType: SpyImageInteractor.self))
    }

    override func tearDown() {
        sut = nil
        interactor = nil

        SpyImageInteractor.clean()

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

// MARK: - title
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

        XCTAssertEqual(SpyImageInteractor.shared.getImageUrlArg, "th2")
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
