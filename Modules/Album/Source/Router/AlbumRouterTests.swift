@testable import Album

import Core

import XCTest

final class AlbumRouterTests: XCTestCase {

    private var navController: SpyNavigationController!
    private var sut: AlbumRouter!

    override func setUp() {
        super.setUp()

        navController = SpyNavigationController()
        sut = AlbumRouter(parent: navController)
    }

    override func tearDown() {
        sut = nil
        navController = nil

        super.tearDown()
    }
}

// MARK: - presentCollection
extension AlbumRouterTests {
    func test_presentCollection_callsNavController() {
        sut.presentCollection()

        XCTAssertEqual(navController.setRootViewControllerCallsCount, 1)
    }

    func test_presentCollection_callsNavControllerWithRightArg() {
        sut.presentCollection()

        XCTAssertTrue(navController.setRootViewControllerArg is PhotoCollectionViewController)
    }
}
