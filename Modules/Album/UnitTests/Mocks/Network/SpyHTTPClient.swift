import Core

final class SpyHTTPClient: HTTPClientProtocol {

    private(set) var fetchCallsCount = 0
    private(set) var fetchRequestsArg = [HTTPRequest]()
    var forcedFetchResult = [Result<HTTPResponse, HTTPError>]()

    private(set) var cancelCallsCount = 0

    func fetch(with request: HTTPRequest, completion: @escaping HTTPClientCompletion) {
        fetchRequestsArg.append(request)

        let result = forcedFetchResult[fetchCallsCount]

        fetchCallsCount += 1

        completion(result)
    }

    func cancel() {
        cancelCallsCount += 1
    }
}
