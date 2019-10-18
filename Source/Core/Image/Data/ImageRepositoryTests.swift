@testable import MSSampleiOS

import XCTest

final class ImageRepositoryTests: XCTestCase {

    private var sut: ImageRepository!
    private var httpClient: SpyHTTPClient!

    override func setUp() {
        super.setUp()

        httpClient = SpyHTTPClient()
        sut = ImageRepository(dependencies: .init(httpClient: httpClient))
    }

    override func tearDown() {
        sut = nil
        httpClient = nil

        super.tearDown()
    }
}

// MARK: - getImage
extension ImageRepositoryTests {
    func test_getImage_callsHttpClient() {
        sut.getImage(at: "") { _ in }

        XCTAssertEqual(httpClient.fetchCallsCount, 1)
    }

    func test_getImage_callsHttpClientWithRightArg() {
        sut.getImage(at: "www.google.com") { _ in }

        XCTAssertEqual(httpClient.fetchRequestArg.url, "www.google.com")
        XCTAssertEqual(httpClient.fetchRequestArg.method, .GET)
        XCTAssertNil(httpClient.fetchRequestArg.body)
    }
}
