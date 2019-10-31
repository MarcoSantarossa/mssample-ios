import Foundation

protocol PhotoCollectionRepositoryProtocol: AnyObject {
    func getPhotos(completion: @escaping ([PhotoCollectionItem]) -> Void)
}

final class PhotoCollectionRepository: PhotoCollectionRepositoryProtocol {

    private let dependencies: Dependencies

    init(dependencies: Dependencies = .init()) {
        self.dependencies = dependencies
    }

    func getPhotos(completion: @escaping ([PhotoCollectionItem]) -> Void) {
        let request = HTTPRequest(url: "\(AppConfiguration.apiBaseUrl)/photos?albumId=1", method: .GET)
        dependencies.httpClient.fetch(with: request) { [weak self] result in
            guard let self = self else { return }
            guard case .success(let response) = result,
                let body = response.body else {
                completion([])
                return
            }

            let items = self.getItems(from: body)
            completion(items)
        }
    }

    private func getItems(from data: Data) -> [PhotoCollectionItem] {
        guard let dtos = try? JSONDecoder().decode([PhotoCollectionItemDTO].self, from: data) else { return [] }
        return dependencies.mapper.map(dtos: dtos)
    }
}

extension PhotoCollectionRepository {
    final class Dependencies {
        let mapper: PhotoCollectionMapperProtocol
        let httpClient: HTTPClientProtocol

        init(mapper: PhotoCollectionMapperProtocol = PhotoCollectionMapper(),
             httpClient: HTTPClientProtocol = HTTPClient()) {
            self.mapper = mapper
            self.httpClient = httpClient
        }
    }
}
