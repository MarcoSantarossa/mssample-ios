import Foundation

typealias HTTPClientCompletion = (Result<HTTPResponse, HTTPError>) -> Void

protocol HTTPClientProtocol: AnyObject {
    func fetch(with request: HTTPRequest, completion: @escaping HTTPClientCompletion)

    func cancel()
}

final class HTTPClient: HTTPClientProtocol {

    private let urlSession: URLSessionProtocol
    private var dataTask: URLSessionDataTaskProtocol?

    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }

    func fetch(with request: HTTPRequest, completion: @escaping HTTPClientCompletion) {

        let urlRequest = createURLRequest(from: request)
        dataTask = urlSession.createHTTPTask(with: urlRequest) { data, httpResponse, error in
            if let error = error {
                completion(.failure(._unknown(error)))
                return
            }

            guard
                let data = data,
                let httpResponse = httpResponse else {
                completion(.failure(.dataNotAvailable))
                return
            }

            let response = HTTPResponse(statusCode: httpResponse.statusCode, body: data)
            if httpResponse.statusCode >= 300 {
                completion(.failure(.apiStatusError(response)))
                return
            }

            completion(.success(response))
        }
        dataTask?.resume()
    }

    private func createURLRequest(from request: HTTPRequest) -> URLRequest {
        var urlRequest = URLRequest(url: URL(string: request.url)!)
        urlRequest.httpBody = request.body
        urlRequest.httpMethod = request.method.rawValue
        return urlRequest
    }

    func cancel() {
        dataTask?.cancel()
    }

    deinit {
        dataTask?.cancel()
    }
}
