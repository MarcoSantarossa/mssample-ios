import Foundation

public struct HTTPRequest {
    public let url: String
    public let method: Method
    public let body: Data?

    public init(url: String, method: Method, body: Data? = nil) {
        self.url = url
        self.method = method
        self.body = body
    }
}

extension HTTPRequest {
    public enum Method: String {
        case GET
        case POST
    }
}
