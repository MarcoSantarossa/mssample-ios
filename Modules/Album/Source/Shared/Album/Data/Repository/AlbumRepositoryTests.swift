@testable import Album

import XCTest

final class AlbumRepositoryTests: XCTestCase {

    private var sut: AlbumRepository!
    private var httpClient: SpyHTTPClient!
    private var mapper: SpyAlbumMapper!

    override func setUp() {
        super.setUp()

        httpClient = SpyHTTPClient()
        mapper = SpyAlbumMapper()

        sut = AlbumRepository(dependencies: .init(httpClient: httpClient, mapper: mapper))
    }

    override func tearDown() {
        sut = nil
        mapper = nil
        httpClient = nil

        super.tearDown()
    }

    private func createAlbumJSONData() -> Data {
        return """
        {
            "id": 10,
            "title": "album title"
        }
        """.data(using: .utf8)!
    }

    private func createPhotosJSONData() -> Data {
        return """
        [
          {
            "albumId": 1,
            "id": 1,
            "title": "photo 1",
            "url": "https://via.placeholder.com/600/92c952",
            "thumbnailUrl": "https://via.placeholder.com/150/92c952"
          },
          {
            "albumId": 1,
            "id": 2,
            "title": "photo 2",
            "url": "https://via.placeholder.com/600/771796",
            "thumbnailUrl": "https://via.placeholder.com/150/771796"
          }
        ]
        """.data(using: .utf8)!
    }

    private func createAlbum() -> Album {
        return Album(id: 1, title: "Album 1", photos: [])
    }
}

// MARK: - getAlbum
extension AlbumRepositoryTests {
    func test_getAlbum_callsHTTPClient() {
        httpClient.forcedFetchResult.append(.failure(.dataNotAvailable))

        sut.getAlbum { _ in }

        XCTAssertEqual(httpClient.fetchCallsCount, 1)
    }

    func test_getAlbum_callsHTTPClientWithRightArgs() {
        httpClient.forcedFetchResult.append(.failure(.dataNotAvailable))

        sut.getAlbum { _ in }

        XCTAssertEqual(httpClient.fetchRequestsArg[0].url, "https://jsonplaceholder.typicode.com/albums/1")
        XCTAssertEqual(httpClient.fetchRequestsArg[0].method, .GET)
        XCTAssertNil(httpClient.fetchRequestsArg[0].body)
    }

    func test_getAlbum_error_callCompletion() {
        httpClient.forcedFetchResult.append(.failure(.dataNotAvailable))
        var completionCallsCount = 0

        sut.getAlbum { _ in completionCallsCount += 1 }

        XCTAssertEqual(completionCallsCount, 1)
    }

    func test_getAlbum_error_callCompletionWithNil() {
        httpClient.forcedFetchResult.append(.failure(.dataNotAvailable))
        var completionArg: Album?

        sut.getAlbum { completionArg = $0 }

        XCTAssertNil(completionArg)
    }

    func test_getAlbum_invalidData_callCompletion() {
        httpClient.forcedFetchResult.append(.success(.init(statusCode: 200, body: "test".data(using: .utf8))))
        var completionCallsCount = 0

        sut.getAlbum { _ in completionCallsCount += 1 }

        XCTAssertEqual(completionCallsCount, 1)
    }

    func test_getAlbum_invalidData_callCompletionWithNil() {
        httpClient.forcedFetchResult.append(.success(.init(statusCode: 200, body: "test".data(using: .utf8))))
        var completionArg: Album?

        sut.getAlbum { completionArg = $0 }

        XCTAssertNil(completionArg)
    }

    func test_getAlbum_invalidData_doesNotCallNextHTTPClient() {
        httpClient.forcedFetchResult.append(.success(.init(statusCode: 200, body: "test".data(using: .utf8))))

        sut.getAlbum { _ in }

        XCTAssertEqual(httpClient.fetchCallsCount, 1)
    }

    func test_getAlbum_validData_callsNextHTTPClient() {
        httpClient.forcedFetchResult.append(.success(.init(statusCode: 200, body: createAlbumJSONData())))
        httpClient.forcedFetchResult.append(.failure(.dataNotAvailable))
        mapper.forcedMapResult = createAlbum()

        sut.getAlbum { _ in }

        XCTAssertEqual(httpClient.fetchCallsCount, 2)
    }

    func test_getAlbum_validData_callsHTTPClientWithRightArgs() {
        httpClient.forcedFetchResult.append(.success(.init(statusCode: 200, body: createAlbumJSONData())))
        httpClient.forcedFetchResult.append(.failure(.dataNotAvailable))
        mapper.forcedMapResult = createAlbum()

        sut.getAlbum { _ in }

        XCTAssertEqual(httpClient.fetchRequestsArg[1].url, "https://jsonplaceholder.typicode.com/photos?albumId=10")
        XCTAssertEqual(httpClient.fetchRequestsArg[1].method, .GET)
        XCTAssertNil(httpClient.fetchRequestsArg[1].body)
    }

    func test_getAlbum_photoResponseReturnsError_callsCompletion() {
        httpClient.forcedFetchResult.append(.success(.init(statusCode: 200, body: createAlbumJSONData())))
        httpClient.forcedFetchResult.append(.failure(.dataNotAvailable))
        mapper.forcedMapResult = createAlbum()

        var completionCallsCount = 0

        sut.getAlbum { _ in completionCallsCount += 1 }

        XCTAssertEqual(completionCallsCount, 1)
    }

    func test_getAlbum_photoResponseReturnsError_callsMapper() {
        httpClient.forcedFetchResult.append(.success(.init(statusCode: 200, body: createAlbumJSONData())))
        httpClient.forcedFetchResult.append(.failure(.dataNotAvailable))
        mapper.forcedMapResult = createAlbum()

        sut.getAlbum { _ in }

        XCTAssertEqual(mapper.mapCallsCount, 1)
    }

    func test_getAlbum_photoResponseReturnsError_callsMapperWithRightArgs() {
        httpClient.forcedFetchResult.append(.success(.init(statusCode: 200, body: createAlbumJSONData())))
        httpClient.forcedFetchResult.append(.failure(.dataNotAvailable))
        mapper.forcedMapResult = createAlbum()

        sut.getAlbum { _ in }

        XCTAssertEqual(mapper.mapAlbumDTOArg.id, 10)
        XCTAssertEqual(mapper.mapAlbumDTOArg.title, "album title")
        XCTAssertEqual(mapper.mapPhotoDTOs.count, 0)
    }

    func test_getAlbum_photoResponseReturnsInvalidData_callsCompletion() {
        httpClient.forcedFetchResult.append(.success(.init(statusCode: 200, body: createAlbumJSONData())))
        httpClient.forcedFetchResult.append(.success(.init(statusCode: 200, body: "test".data(using: .utf8))))
        mapper.forcedMapResult = createAlbum()

        var completionCallsCount = 0

        sut.getAlbum { _ in completionCallsCount += 1 }

        XCTAssertEqual(completionCallsCount, 1)
    }

    func test_getAlbum_photoResponseReturnsInvalidData_callsMapper() {
        httpClient.forcedFetchResult.append(.success(.init(statusCode: 200, body: createAlbumJSONData())))
        httpClient.forcedFetchResult.append(.success(.init(statusCode: 200, body: "test".data(using: .utf8))))
        mapper.forcedMapResult = createAlbum()

        sut.getAlbum { _ in }

        XCTAssertEqual(mapper.mapCallsCount, 1)
    }

    func test_getAlbum_photoResponseReturnsInvalidData_callsMapperWithRightArgs() {
        httpClient.forcedFetchResult.append(.success(.init(statusCode: 200, body: createAlbumJSONData())))
        httpClient.forcedFetchResult.append(.success(.init(statusCode: 200, body: "test".data(using: .utf8))))
        mapper.forcedMapResult = createAlbum()

        sut.getAlbum { _ in }

        XCTAssertEqual(mapper.mapAlbumDTOArg.id, 10)
        XCTAssertEqual(mapper.mapAlbumDTOArg.title, "album title")
        XCTAssertEqual(mapper.mapPhotoDTOs.count, 0)
    }

    func test_getAlbum_photoResponseReturnsValidData_callsCompletion() {
        httpClient.forcedFetchResult.append(.success(.init(statusCode: 200, body: createAlbumJSONData())))
        httpClient.forcedFetchResult.append(.success(.init(statusCode: 200, body: createPhotosJSONData())))
        mapper.forcedMapResult = createAlbum()

        var completionCallsCount = 0

        sut.getAlbum { _ in completionCallsCount += 1 }

        XCTAssertEqual(completionCallsCount, 1)
    }

    func test_getAlbum_photoResponseReturnsValidData_callsMapper() {
        httpClient.forcedFetchResult.append(.success(.init(statusCode: 200, body: createAlbumJSONData())))
        httpClient.forcedFetchResult.append(.success(.init(statusCode: 200, body: createPhotosJSONData())))
        mapper.forcedMapResult = createAlbum()

        sut.getAlbum { _ in }

        XCTAssertEqual(mapper.mapCallsCount, 1)
    }

    func test_getAlbum_photoResponseReturnsValidData_callsMapperWithRightArgs() {
        httpClient.forcedFetchResult.append(.success(.init(statusCode: 200, body: createAlbumJSONData())))
        httpClient.forcedFetchResult.append(.success(.init(statusCode: 200, body: createPhotosJSONData())))
        mapper.forcedMapResult = createAlbum()

        sut.getAlbum { _ in }

        XCTAssertEqual(mapper.mapAlbumDTOArg.id, 10)
        XCTAssertEqual(mapper.mapAlbumDTOArg.title, "album title")
        XCTAssertEqual(mapper.mapPhotoDTOs.count, 2)
        XCTAssertEqual(mapper.mapPhotoDTOs[0].id, 1)
        XCTAssertEqual(mapper.mapPhotoDTOs[0].title, "photo 1")
        XCTAssertEqual(mapper.mapPhotoDTOs[0].url, "https://via.placeholder.com/600/92c952")
        XCTAssertEqual(mapper.mapPhotoDTOs[0].thumbnailUrl, "https://via.placeholder.com/150/92c952")
        XCTAssertEqual(mapper.mapPhotoDTOs[1].id, 2)
        XCTAssertEqual(mapper.mapPhotoDTOs[1].title, "photo 2")
        XCTAssertEqual(mapper.mapPhotoDTOs[1].url, "https://via.placeholder.com/600/771796")
        XCTAssertEqual(mapper.mapPhotoDTOs[1].thumbnailUrl, "https://via.placeholder.com/150/771796")
    }
}
