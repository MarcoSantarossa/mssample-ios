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

    func test_getImage_callsCompletion() {
        var completionCallsCount = 0
        httpClient.forcedFetchResult = .failure(.dataNotAvailable)

        sut.getImage(at: "www.google.com") { _ in completionCallsCount += 1 }

        XCTAssertEqual(completionCallsCount, 1)
    }

    func test_getImage_httpClientReturnsError_returnsNil() {
        var arg: Image?
        httpClient.forcedFetchResult = .failure(.dataNotAvailable)

        sut.getImage(at: "www.google.com") { arg = $0 }

        XCTAssertNil(arg)
    }

    func test_getImage_httpClientReturnsSuccess_returnsImage() {
        let data = "tests".data(using: .utf8)
        var arg: Image!
        httpClient.forcedFetchResult = .success(.init(statusCode: 200, body: data))

        sut.getImage(at: "www.google.com") { arg = $0 }

        XCTAssertEqual(arg.id, "www.google.com")
        XCTAssertEqual(arg.data, data)
    }
}
