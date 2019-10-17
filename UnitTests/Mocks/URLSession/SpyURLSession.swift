@testable import MSSampleiOS

import Foundation

// swiftlint:disable large_tuple
final class SpyURLSession: URLSessionProtocol {

    private(set) var createHTTPTaskCallsCount = 0
    private(set) var createHTTPTaskRequestArg: URLRequest!

    var forcedCreateHTTPTaskCompletion: (Data?, SpyHTTPURLResponse?, Error?)?
    var forcedCreateHTTPTaskDataTask: SpyURLSessionDataTask!

    func createHTTPTask(with request: URLRequest, completionHandler: @escaping (Data?, HTTPURLResponseProtocol?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        createHTTPTaskCallsCount += 1
        createHTTPTaskRequestArg = request

        if let forcedCreateHTTPTaskCompletion = forcedCreateHTTPTaskCompletion {
            completionHandler(forcedCreateHTTPTaskCompletion.0, forcedCreateHTTPTaskCompletion.1, forcedCreateHTTPTaskCompletion.2)
        }

        return forcedCreateHTTPTaskDataTask
    }
}
