import Foundation

public protocol URLSessionProtocol: AnyObject {
    func createHTTPTask(with request: URLRequest, completionHandler: @escaping (Data?, HTTPURLResponseProtocol?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

extension URLSession: URLSessionProtocol {
    public func createHTTPTask(with request: URLRequest, completionHandler: @escaping (Data?, HTTPURLResponseProtocol?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        let sessionCompletionHandler: (Data?, URLResponse?, Error?) -> Void = {
            completionHandler($0, $1 as? HTTPURLResponse, $2)
        }
        return self.dataTask(with: request, completionHandler: sessionCompletionHandler)
    }
}

public protocol URLSessionDataTaskProtocol: AnyObject {
    func resume()
    func cancel()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}

public protocol HTTPURLResponseProtocol: AnyObject {
    var statusCode: Int { get }
}

extension HTTPURLResponse: HTTPURLResponseProtocol {}
