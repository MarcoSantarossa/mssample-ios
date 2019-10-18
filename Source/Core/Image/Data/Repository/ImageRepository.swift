import Foundation

protocol ImageRepositoryProtocol: AnyObject {
    func getImage(at url: String, completion: @escaping (Image) -> Void)

    func cancel()
}

final class ImageRepository: ImageRepositoryProtocol {
    private let dependencies: Dependencies

    init(dependencies: Dependencies = .init()) {
        self.dependencies = dependencies
    }

    func getImage(at url: String, completion: @escaping (Image) -> Void) {
        let request = HTTPRequest(url: url, method: .GET)
        dependencies.httpClient.fetch(with: request) { result in
            guard
                case .success(let response) = result,
                let data = response.body else {
                return
            }

            let image = Image(id: url, data: data)
            completion(image)
        }
    }

    func cancel() {
        dependencies.httpClient.cancel()
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
