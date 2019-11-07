@testable import Album

import XCTest

final class PhotoDetailsPresenterTests: XCTestCase {

    private var sut: PhotoDetailsPresenter!
    private var albumInteractor: SpyAlbumInteractor!
    private var imageInteractor: SpyImageInteractor!

    override func setUp() {
        super.setUp()

        albumInteractor = SpyAlbumInteractor()
        imageInteractor = SpyImageInteractor()
        sut = PhotoDetailsPresenter(photoId: 3, dependencies: .init(albumInteractor: albumInteractor, imageInteractor: imageInteractor))
    }

    override func tearDown() {
        sut = nil
        albumInteractor = nil
        imageInteractor = nil

        SpyImageInteractor.forcedGetImage = nil

        super.tearDown()
    }

    private func loadPhoto(_ photo: Photo? = Photo(id: 1, title: "t1", url: "u1", thumbnailUrl: "tu1")) {
        albumInteractor.getPhotoForcedResult = photo
        sut.viewDidLoad()
    }
}

// MARK: - state
extension PhotoDetailsPresenterTests {
    func test_state_default_returnsLoading() {
        let result = sut.state

        XCTAssertEqual(result, .loading)
    }

    func test_state_loadPhotoNil_returnsDataNotFound() {
        loadPhoto(nil)

        let result = sut.state

        XCTAssertEqual(result, .dataNotFound)
    }

    func test_state_loadPhoto_returnsDataAvailable() {
        loadPhoto()

        let result = sut.state

        XCTAssertEqual(result, .dataAvailable)
    }
}

// MARK: - viewDidLoad
extension PhotoDetailsPresenterTests {
    func test_viewDidLoad_callsInteractor() {
        sut.viewDidLoad()

        XCTAssertEqual(albumInteractor.getPhotoCallsCount, 1)
    }

    func test_viewDidLoad_callsInteractorWithRightArg() {
        sut.viewDidLoad()

        XCTAssertEqual(albumInteractor.getPhotoIdArg, 3)
    }

    func test_viewDidLoad_photoNil_callsUpdate() {
        albumInteractor.getPhotoForcedResult = nil
        var updateCallsCount = 0
        sut.onStateDidChange = { _ in updateCallsCount += 1 }

        sut.viewDidLoad()

        XCTAssertEqual(updateCallsCount, 1)
    }

    func test_viewDidLoad_photoNil_callsUpdateWithRightArg() {
        albumInteractor.getPhotoForcedResult = nil
        var updateState: PhotoDetailsPresenterState!
        sut.onStateDidChange = { updateState = $0 }

        sut.viewDidLoad()

        XCTAssertEqual(updateState, .dataNotFound)
    }

    func test_viewDidLoad_photoNotNil_callsUpdate() {
        albumInteractor.getPhotoForcedResult = Photo(id: 1, title: "t1", url: "u1", thumbnailUrl: "tu1")
        var updateState: PhotoDetailsPresenterState!
        sut.onStateDidChange = { updateState = $0 }

        sut.viewDidLoad()

        XCTAssertEqual(updateState, .dataAvailable)
    }
}

// MARK: - photoTitle
extension PhotoDetailsPresenterTests {
    func test_photoTitle_beforeLoadingPhoto_returnsEmpty() {
        let result = sut.photoTitle

        XCTAssertEqual(result, "")
    }

    func test_photoTitle_loadPhotoNil_returnsExpectedValue() {
        loadPhoto(nil)

        let result = sut.photoTitle

        XCTAssertEqual(result, "")
    }

    func test_photoTitle_loadPhoto_returnsExpectedValue() {
        loadPhoto()

        let result = sut.photoTitle

        XCTAssertEqual(result, "t1")
    }
}

// MARK: - getImage
extension PhotoDetailsPresenterTests {
    func test_getImage_beforeLoadingPhoto_doesNotCallInteractor() {
        sut.getImage { _ in }

        XCTAssertEqual(imageInteractor.getImageCallsCount, 0)
    }

    func test_getImage_loadPhotoNil_doesNotCallInteractor() {
        loadPhoto(nil)

        sut.getImage { _ in }

        XCTAssertEqual(imageInteractor.getImageCallsCount, 0)
    }

    func test_getImage_loadValidPhoto_callsInteractor() {
        loadPhoto()

        sut.getImage { _ in }

        XCTAssertEqual(imageInteractor.getImageCallsCount, 1)
    }

    func test_getImage_loadValidPhoto_callsInteractorWithRightArgs() {
        loadPhoto()

        sut.getImage { _ in }

        XCTAssertEqual(imageInteractor.getImageUrlArg, "u1")
    }

    func test_getImage_interactorCallsCompletions_callsCompletion() {
        loadPhoto()
        SpyImageInteractor.forcedGetImage = Image(id: "2323", data: "test".data(using: .utf8)!)
        var completionCallsCount = 0

        sut.getImage { _ in completionCallsCount += 1 }

        XCTAssertEqual(completionCallsCount, 1)
    }

    func test_getImage_interactorCallsCompletions_callsCompletionWithRightArg() {
        loadPhoto()
        let data = "test".data(using: .utf8)!
        SpyImageInteractor.forcedGetImage = Image(id: "2323", data: data)
        var completionArg: Data!

        sut.getImage { completionArg = $0 }

        XCTAssertEqual(completionArg, data)
    }
}
