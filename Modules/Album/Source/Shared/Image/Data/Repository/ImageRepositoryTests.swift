@testable import Album

import CoreMock
import XCTest

final class ImageRepositoryTests: XCTestCase {

    private var sut: ImageRepository!
    private var httpClient: SpyHTTPClient!
    private var imageCache: SpyCache<NSString, Image>!

    override func setUp() {
        super.setUp()

        httpClient = SpyHTTPClient()
        imageCache = SpyCache<NSString, Image>()
        sut = ImageRepository(dependencies: .init(httpClient: httpClient, imageCache: imageCache))
    }

    override func tearDown() {
        sut = nil
        httpClient = nil
        imageCache = nil

        super.tearDown()
    }
}

// MARK: - getImage
extension ImageRepositoryTests {
    func test_getImage_cacheAvailable_doesNotCallHttpClient() {
        let data = "tests".data(using: .utf8)!
        let image = Image(id: "www.google.com", data: data)
        imageCache.forcedGetValue["www.google.com"] = image

        sut.getImage(at: "www.google.com") { _ in }

        XCTAssertEqual(httpClient.fetchCallsCount, 0)
    }

    func test_getImage_cacheAvailable_returnsExpectedImage() {
        let data = "tests".data(using: .utf8)!
        let image = Image(id: "www.google.com", data: data)
        imageCache.forcedGetValue["www.google.com"] = image
        var arg: Image!

        sut.getImage(at: "www.google.com") { arg = $0 }

        XCTAssertEqual(arg.id, "www.google.com")
        XCTAssertEqual(arg.data, data)
    }

    func test_getImage_cacheNotAvailable_callsHttpClient() {
        imageCache.forcedGetValue["test"] = nil

        httpClient.forcedFetchResult.append(.failure(.dataNotAvailable))

        sut.getImage(at: "test") { _ in }

        XCTAssertEqual(httpClient.fetchCallsCount, 1)
    }

    func test_getImage_callsHttpClientWithRightArg() {
        httpClient.forcedFetchResult.append(.failure(.dataNotAvailable))

        sut.getImage(at: "www.google.com") { _ in }

        XCTAssertEqual(httpClient.fetchRequestsArg[0].url, "www.google.com")
        XCTAssertEqual(httpClient.fetchRequestsArg[0].method, .GET)
        XCTAssertNil(httpClient.fetchRequestsArg[0].body)
    }

    func test_getImage_httpClientReturnsError_doesNotCallCompletion() {
        var completionCallsCount = 0
        httpClient.forcedFetchResult.append(.failure(.dataNotAvailable))

        sut.getImage(at: "www.google.com") { _ in completionCallsCount += 1 }

        XCTAssertEqual(completionCallsCount, 0)
    }

    func test_getImage_httpClientReturnsError_doesNotCallCache() {
        httpClient.forcedFetchResult.append(.failure(.dataNotAvailable))

        sut.getImage(at: "www.google.com") { _ in }

        XCTAssertEqual(imageCache.setCallsCount, 0)
    }

    func test_getImage_httpClientReturnsSuccess_returnsImage() {
        let data = "tests".data(using: .utf8)
        var arg: Image!
        httpClient.forcedFetchResult.append(.success(.init(statusCode: 200, body: data)))

        sut.getImage(at: "www.google.com") { arg = $0 }

        XCTAssertEqual(arg.id, "www.google.com")
        XCTAssertEqual(arg.data, data)
    }

    func test_getImage_httpClientReturnsSuccess_callsCacheWithRightArgs() {
        let data = "tests".data(using: .utf8)
        httpClient.forcedFetchResult.append(.success(.init(statusCode: 200, body: data)))

        sut.getImage(at: "www.google.com") { _ in }

        XCTAssertEqual(imageCache.setValueArg.id, "www.google.com")
        XCTAssertEqual(imageCache.setValueArg.data, data)
        XCTAssertEqual(imageCache.setKeyArg, "www.google.com")
    }
}

// MARK: - cancel
extension ImageRepositoryTests {
    func test_cancel_callsHttpClient() {
        sut.cancel()

        XCTAssertEqual(httpClient.cancelCallsCount, 1)
    }
}
