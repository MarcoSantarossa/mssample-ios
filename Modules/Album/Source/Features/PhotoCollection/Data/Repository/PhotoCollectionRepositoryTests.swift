@testable import Album

import Core
import XCTest

final class PhotoCollectionRepositoryTests: XCTestCase {

    private var sut: PhotoCollectionRepository!
    private var httpClient: SpyHTTPClient!
    private var mapper: SpyPhotoCollectionMapper!

    private var validResponseData: Data {
        return "[{\"albumId\":1,\"id\":1,\"title\":\"t1\",\"url\":\"https://via.placeholder.com/600/92c952\",\"thumbnailUrl\":\"th1\"},{\"albumId\":1,\"id\":2,\"title\":\"t2\",\"url\":\"https://via.placeholder.com/600/771796\",\"thumbnailUrl\":\"th2\"},{\"albumId\":1,\"id\":3,\"title\":\"t3\",\"url\":\"https://via.placeholder.com/600/24f355\",\"thumbnailUrl\":\"th3\"}]".data(using: .utf8)!
    }

    override func setUp() {
        super.setUp()

        httpClient = SpyHTTPClient()
        mapper = SpyPhotoCollectionMapper()

        sut = PhotoCollectionRepository(dependencies: .init(mapper: mapper, httpClient: httpClient))
    }

    override func tearDown() {
        sut = nil
        httpClient = nil
        mapper = nil

        super.tearDown()
    }
}

// MARK: - getPhotos
extension PhotoCollectionRepositoryTests {
    func test_getPhotos_callsHTTPClient() {
        sut.getPhotos { _ in }

        XCTAssertEqual(httpClient.fetchCallsCount, 1)
    }

    func test_getPhotos_callsHTTPClientWithRightArgs() {
        sut.getPhotos { _ in }

        XCTAssertEqual(httpClient.fetchRequestArg.url, "https://jsonplaceholder.typicode.com/photos?albumId=1")
        XCTAssertEqual(httpClient.fetchRequestArg.method, .GET)
        XCTAssertNil(httpClient.fetchRequestArg.body, "https://jsonplaceholder.typicode.com/photos?albumId=1")
    }

    func test_getPhotos_httpClientReturnsError_returnsEmptyItems() {
        httpClient.forcedFetchResult = .failure(.dataNotAvailable)
        var itemsArg: [PhotoCollectionItem]!

        sut.getPhotos { itemsArg = $0 }

        XCTAssertEqual(itemsArg.count, 0)
    }

    func test_getPhotos_httpClientReturnsWithoutData_returnsEmptyItems() {
        httpClient.forcedFetchResult = .success(HTTPResponse(statusCode: 200, body: nil))
        var itemsArg: [PhotoCollectionItem]!

        sut.getPhotos { itemsArg = $0 }

        XCTAssertEqual(itemsArg.count, 0)
    }

    func test_getPhotos_httpClientReturnsInvalidData_returnsEmptyItems() {
        let data = "test".data(using: .utf8)
        httpClient.forcedFetchResult = .success(HTTPResponse(statusCode: 200, body: data))
        var itemsArg: [PhotoCollectionItem]!

        sut.getPhotos { itemsArg = $0 }

        XCTAssertEqual(itemsArg.count, 0)
    }

    func test_getPhotos_httpClientReturnsInvalidData_doesNotCallMapper() {
        let data = "test".data(using: .utf8)
        httpClient.forcedFetchResult = .success(HTTPResponse(statusCode: 200, body: data))

        sut.getPhotos { _ in }

        XCTAssertEqual(mapper.mapCallsCount, 0)
    }

    func test_getPhotos_httpClientReturnsValidData_callsMapper() {
        httpClient.forcedFetchResult = .success(HTTPResponse(statusCode: 200, body: validResponseData))
        mapper.forcedMap = []

        sut.getPhotos { _ in }

        XCTAssertEqual(mapper.mapCallsCount, 1)
    }

    func test_getPhotos_httpClientReturnsValidData_callsMapperWithRightArgs() {
        httpClient.forcedFetchResult = .success(HTTPResponse(statusCode: 200, body: validResponseData))
        mapper.forcedMap = []

        sut.getPhotos { _ in }

        XCTAssertEqual(mapper.mapDtosArg.count, 3)
        XCTAssertEqual(mapper.mapDtosArg[0].id, 1)
        XCTAssertEqual(mapper.mapDtosArg[0].title, "t1")
        XCTAssertEqual(mapper.mapDtosArg[0].thumbnailUrl, "th1")
        XCTAssertEqual(mapper.mapDtosArg[1].id, 2)
        XCTAssertEqual(mapper.mapDtosArg[1].title, "t2")
        XCTAssertEqual(mapper.mapDtosArg[1].thumbnailUrl, "th2")
        XCTAssertEqual(mapper.mapDtosArg[2].id, 3)
        XCTAssertEqual(mapper.mapDtosArg[2].title, "t3")
        XCTAssertEqual(mapper.mapDtosArg[2].thumbnailUrl, "th3")
    }

    func test_getPhotos_mapperReturnsArray_returnsArray() {
        httpClient.forcedFetchResult = .success(HTTPResponse(statusCode: 200, body: validResponseData))
        mapper.forcedMap = [.init(id: 1, title: "t1", thumbnailUrl: "th1")]
        var itemsArg: [PhotoCollectionItem]!

        sut.getPhotos { itemsArg = $0 }

        XCTAssertEqual(itemsArg, mapper.forcedMap)
    }

}
