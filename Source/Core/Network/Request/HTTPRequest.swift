import Foundation

struct HTTPRequest {
    let url: String
    let method: Method
    let body: Data?

    init(url: String, method: Method, body: Data? = nil) {
        self.url = url
        self.method = method
        self.body = body
    }
}

extension HTTPRequest {
    enum Method: String {
        case GET
        case POST
    }
}
