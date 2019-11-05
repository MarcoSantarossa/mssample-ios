import Core

public final class SpyHTTPClient: HTTPClientProtocol {

    public private(set) var fetchCallsCount = 0
    public private(set) var fetchRequestsArg = [HTTPRequest]()
    public var forcedFetchResult = [Result<HTTPResponse, HTTPError>]()

    public private(set) var cancelCallsCount = 0

    public init() {}

    public func fetch(with request: HTTPRequest, completion: @escaping HTTPClientCompletion) {
        fetchRequestsArg.append(request)

        let result = forcedFetchResult[fetchCallsCount]

        fetchCallsCount += 1

        completion(result)
    }

    public func cancel() {
        cancelCallsCount += 1
    }
}
