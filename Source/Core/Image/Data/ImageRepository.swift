import Foundation

protocol ImageRepositoryProtocol: AnyObject {
    func getImage(at url: String, completion: (Image?) -> Void)
}

final class ImageRepository: ImageRepositoryProtocol {
    private let dependencies: Dependencies

    init(dependencies: Dependencies = .init()) {
        self.dependencies = dependencies
    }

    func getImage(at url: String, completion: (Image?) -> Void) {
        let request = HTTPRequest(url: url, method: .GET)
        dependencies.httpClient.fetch(with: request) { result in
            
        }
    }
}

extension ImageRepository {
    final class Dependencies {
        let httpClient: HTTPClientProtocol

        init(httpClient: HTTPClientProtocol = HTTPClient()) {
            self.httpClient = httpClient
        }
    }
}
