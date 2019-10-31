@testable import MSSampleiOS

import XCTest

final class ImageInteractorTests: XCTestCase {

    private var sut: ImageInteractor!
    private var repo: SpyImageRepository!

    override func setUp() {
        super.setUp()

        repo = SpyImageRepository()
        sut = ImageInteractor(dependencies: .init(repo: repo))
    }

    override func tearDown() {
        sut = nil
        repo = nil

        super.tearDown()
    }
}

// MARK: - getImage
extension ImageInteractorTests {
    func test_getImage_callsRepo() {
        sut.getImage(at: "") { _ in }

        XCTAssertEqual(repo.getImageCallsCount, 1)
    }

    func test_getImage_callsRepoWithRightArgs() {
        sut.getImage(at: "www.google.com") { _ in }

        XCTAssertEqual(repo.getImageUrlArg, "www.google.com")
    }

    func test_getImage_completionWithRepoImage() {
        repo.forcedGetImage = Image(id: "1", data: Data())
        var arg: Image!

        sut.getImage(at: "www.google.com") { arg = $0 }

        XCTAssertEqual(arg.id, repo.forcedGetImage?.id)
        XCTAssertEqual(arg.data, repo.forcedGetImage?.data)
    }
}

// MARK: - cancel
extension ImageInteractorTests {
    func test_cancel_callsRepo() {
        sut.cancel()

        XCTAssertEqual(repo.cancelCallsCount, 1)
    }
}
