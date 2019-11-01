@testable import Photo

import Core

import XCTest

final class PhotoFlowTests: XCTestCase {

    private var navController: SpyNavigationController!
    private var sut: PhotoFlow!

    override func setUp() {
        super.setUp()

        navController = SpyNavigationController()
        sut = PhotoFlow(parent: navController)
    }

    override func tearDown() {
        sut = nil
        navController = nil

        super.tearDown()
    }
}

// MARK: - presentCollection
extension PhotoFlowTests {
    func test_presentCollection_callsNavController() {
        sut.presentCollection()

        XCTAssertEqual(navController.setRootViewControllerCallsCount, 1)
    }

    func test_presentCollection_callsNavControllerWithRightArg() {
        sut.presentCollection()

        XCTAssertTrue(navController.setRootViewControllerArg is PhotoCollectionViewController)
    }
}
