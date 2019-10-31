@testable import Core

import XCTest

final class HTTPClientTests: XCTestCase {

    private var sut: HTTPClient!
    private var urlSession: SpyURLSession!

    override func setUp() {
        super.setUp()

        urlSession = SpyURLSession()
        urlSession.forcedCreateHTTPTaskDataTask = SpyURLSessionDataTask()

        sut = HTTPClient(urlSession: urlSession)
    }

    override func tearDown() {
        sut = nil
        urlSession = nil

        super.tearDown()
    }
}

// MARK: - fetch
extension HTTPClientTests {

    func test_fetch_callsURLSession() {
        let request = HTTPRequest(url: "s", method: .GET)

        sut.fetch(with: request) { (_: Result<HTTPResponse, HTTPError>) in }

        XCTAssertEqual(urlSession.createHTTPTaskCallsCount, 1)
    }

    func test_fetch_callsURLSessionWithRightURL() {
        let request = HTTPRequest(url: "https://google.com", method: .GET)

        sut.fetch(with: request) { (_: Result<HTTPResponse, HTTPError>) in }

        XCTAssertEqual(urlSession.createHTTPTaskRequestArg.url!.absoluteString, request.url)
    }

    func test_fetch_withoutBody_callsURLSessionWithEmptyBody() {
        let request = HTTPRequest(url: "https://google.com", method: .GET)

        sut.fetch(with: request) { (_: Result<HTTPResponse, HTTPError>) in }

        XCTAssertNil(urlSession.createHTTPTaskRequestArg.httpBody)
    }

    func test_fetch_withBody_callsURLSessionWithValidBody() {
        let body = "test".data(using: .utf8)
        let request = HTTPRequest(url: "https://google.com", method: .GET, body: body)

        sut.fetch(with: request) { (_: Result<HTTPResponse, HTTPError>) in }

        XCTAssertEqual(urlSession.createHTTPTaskRequestArg.httpBody, body)
    }

    func test_fetch_get_callsURLSessionWithValidMethod() {
        let body = "test".data(using: .utf8)
        let request = HTTPRequest(url: "https://google.com", method: .GET, body: body)

        sut.fetch(with: request) { (_: Result<HTTPResponse, HTTPError>) in }

        XCTAssertEqual(urlSession.createHTTPTaskRequestArg.httpMethod, "GET")
    }

    func test_fetch_post_callsURLSessionWithValidMethod() {
        let body = "test".data(using: .utf8)
        let request = HTTPRequest(url: "https://google.com", method: .POST, body: body)

        sut.fetch(with: request) { (_: Result<HTTPResponse, HTTPError>) in }

        XCTAssertEqual(urlSession.createHTTPTaskRequestArg.httpMethod, "POST")
    }

    func test_fetch_resumesDataTask() {
        let request = HTTPRequest(url: "https://google.com", method: .GET)

        sut.fetch(with: request) { (_: Result<HTTPResponse, HTTPError>) in }
        XCTAssertEqual(urlSession.forcedCreateHTTPTaskDataTask.resumeCallsCount, 1)
    }

    func test_fetch_completionHasError_callsResultWithError() {
        let request = HTTPRequest(url: "https://google.com", method: .GET)
        urlSession.forcedCreateHTTPTaskCompletion = (Data(), nil, DummyError.dummy)
        var resultArg: Result<HTTPResponse, HTTPError>!
        sut.fetch(with: request) { resultArg = $0 }

        guard
            case Result.failure(let error) = resultArg!,
            case HTTPError._unknown(let rawError) = error,
            let unknownError = rawError as? DummyError else {
                XCTFail()
                return
        }

        XCTAssertEqual(unknownError, DummyError.dummy)
    }

    func test_fetch_completionHasNoData_callsResultWithError() {
        let request = HTTPRequest(url: "https://google.com", method: .GET)
        urlSession.forcedCreateHTTPTaskCompletion = (nil, nil, nil)
        var resultArg: Result<HTTPResponse, HTTPError>!
        sut.fetch(with: request) { resultArg = $0 }

        guard
            case Result.failure(let error) = resultArg! else {
                XCTFail()
                return
        }

        switch error {
        case .dataNotAvailable:
            XCTAssertTrue(true)
        default:
            XCTFail()
        }
    }

    func test_fetch_completionHasNoHTTPResponse_callsResultWithError() {
        let request = HTTPRequest(url: "https://google.com", method: .GET)
        urlSession.forcedCreateHTTPTaskCompletion = (Data(), nil, nil)
        var resultArg: Result<HTTPResponse, HTTPError>!
        sut.fetch(with: request) { resultArg = $0 }

        guard
            case Result.failure(let error) = resultArg! else {
                XCTFail()
                return
        }

        switch error {
        case .dataNotAvailable:
            XCTAssertTrue(true)
        default:
            XCTFail()
        }
    }

    func test_fetch_completionHasStatusCodeError_callsResultWithError() {
        let data = "test".data(using: .utf8)
        let httpResponse = SpyHTTPURLResponse()
        httpResponse.statusCode = 400
        let request = HTTPRequest(url: "https://google.com", method: .GET)
        urlSession.forcedCreateHTTPTaskCompletion = (data, httpResponse, nil)
        var resultArg: Result<HTTPResponse, HTTPError>!
        sut.fetch(with: request) { resultArg = $0 }

        guard
            case Result.failure(let error) = resultArg!,
            case HTTPError.apiStatusError(let errorResponse) = error else {
                XCTFail()
                return
        }

        XCTAssertEqual(errorResponse.statusCode, 400)
        XCTAssertEqual(errorResponse.body, data)
    }

    func test_fetch_completionHasStatusCodeSuccess_callsResultWithSuccess() {
        let data = "test".data(using: .utf8)
        let httpResponse = SpyHTTPURLResponse()
        httpResponse.statusCode = 203
        let request = HTTPRequest(url: "https://google.com", method: .GET)
        urlSession.forcedCreateHTTPTaskCompletion = (data, httpResponse, nil)
        var resultArg: Result<HTTPResponse, HTTPError>!
        sut.fetch(with: request) { resultArg = $0 }

        guard case Result.success(let result) = resultArg! else {
            XCTFail()
            return
        }

        XCTAssertEqual(result.statusCode, 203)
        XCTAssertEqual(result.body, data)
    }
}

// MARK: - cancel
extension HTTPClientTests {
    func test_cancel_beforeStartingTask_doesNotCancelDataTask() {
        sut.cancel()

        XCTAssertEqual(urlSession.forcedCreateHTTPTaskDataTask.cancelCallsCount, 0)
    }

    func test_cancel_afterStartingTask_cancelDataTask() {
        let request = HTTPRequest(url: "https://google.com", method: .GET)
        sut.fetch(with: request) { (_: Result<HTTPResponse, HTTPError>) in }

        sut.cancel()

        XCTAssertEqual(urlSession.forcedCreateHTTPTaskDataTask.cancelCallsCount, 1)
    }
}

// MARK: - deinit
extension HTTPClientTests {
    func test_deinit_cancelDataTask() {
        let request = HTTPRequest(url: "https://google.com", method: .GET)
        sut.fetch(with: request) { (_: Result<HTTPResponse, HTTPError>) in }

        sut = nil
    XCTAssertEqual(urlSession.forcedCreateHTTPTaskDataTask.cancelCallsCount, 1)
    }
}

// MARK: - Mock objects

enum DummyError: Error {
    case dummy
}
