import Core

final class SpyHTTPClient: HTTPClientProtocol {

    private(set) var fetchCallsCount = 0
    private(set) var fetchRequestArg: HTTPRequest!
    var forcedFetchResult: Result<HTTPResponse, HTTPError>?

    private(set) var cancelCallsCount = 0

    func fetch(with request: HTTPRequest, completion: @escaping HTTPClientCompletion) {
        fetchCallsCount += 1
        fetchRequestArg = request

        if let forcedFetchResult = forcedFetchResult {
            completion(forcedFetchResult)
        }
    }

    func cancel() {
        cancelCallsCount += 1
    }
}
