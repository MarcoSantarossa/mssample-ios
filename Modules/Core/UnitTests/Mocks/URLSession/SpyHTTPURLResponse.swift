@testable import Core

final class SpyHTTPURLResponse: HTTPURLResponseProtocol {
    var statusCode: Int = 0
}
