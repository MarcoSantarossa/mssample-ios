import Core

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
        if let imageData = dependencies.imageCache.getImageData(key: url) {
            completion(imageData)
            return
        }
        let request = HTTPRequest(url: url, method: .GET)
        dependencies.httpClient.fetch(with: request) { [weak self] result in
            guard
                let self = self,
                case .success(let response) = result,
                let data = response.body else {
                return
            }

            let image = Image(id: url, data: data)
            completion(image)
            self.dependencies.imageCache.setImageData(value: image, key: url)
        }
    }

    func cancel() {
        dependencies.httpClient.cancel()
    }
}

extension ImageRepository {
    final class Dependencies {
        let httpClient: HTTPClientProtocol
        let imageCache: ImageCacheProtocol

        init(httpClient: HTTPClientProtocol = HTTPClient(),
             imageCache: ImageCacheProtocol = AlbumEnvironment.shared.imageCache) {
            self.httpClient = httpClient
            self.imageCache = imageCache
        }
    }
}
