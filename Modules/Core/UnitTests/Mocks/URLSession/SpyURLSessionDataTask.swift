@testable import Core

final class SpyURLSessionDataTask: URLSessionDataTaskProtocol {

    private(set) var resumeCallsCount = 0
    private(set) var cancelCallsCount = 0

    func resume() {
        resumeCallsCount += 1
    }

    func cancel() {
        cancelCallsCount += 1
    }
}
