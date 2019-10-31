import Foundation

public struct HTTPResponse {
    public let statusCode: Int
    public let body: Data?

    public init(statusCode: Int, body: Data?) {
        self.statusCode = statusCode
        self.body = body
    }
}
