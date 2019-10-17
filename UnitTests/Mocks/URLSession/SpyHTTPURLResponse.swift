@testable import MSSampleiOS

final class SpyHTTPURLResponse: HTTPURLResponseProtocol {
    var statusCode: Int = 0
}
