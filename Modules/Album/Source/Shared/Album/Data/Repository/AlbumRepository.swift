import Core

protocol AlbumRepositoryProtocol: AnyObject {
    func getAlbum(completion: @escaping (Album?) -> Void)
}

final class AlbumRepository: AlbumRepositoryProtocol {
    private let dependencies: Dependencies
    private let albumId = 1

    init(dependencies: Dependencies = .init()) {
        self.dependencies = dependencies
    }

    func getAlbum(completion: @escaping (Album?) -> Void) {
        let request = HTTPRequest(url: "\(AppConfiguration.apiBaseUrl)/albums/\(albumId)", method: .GET)

        dependencies.httpClient.fetch(with: request) { [weak self] result in
            guard let self = self else { return }
            guard case .success(let response) = result,
                let body = response.body else {
                    completion(nil)
                    return
            }

            do {
                let albumDTO = try JSONDecoder().decode(AlbumDTO.self, from: body)
                self.getPhotos(albumId: albumDTO.id) { photoDTOs in
                    let album = self.dependencies.mapper.map(albumDTO: albumDTO, photoDTOs: photoDTOs)
                    completion(album)
                }
            } catch {
                completion(nil)
            }
        }
    }

    private func getPhotos(albumId: Int, completion: @escaping ([PhotoDTO]) -> Void) {
        let request = HTTPRequest(url: "\(AppConfiguration.apiBaseUrl)/photos?albumId=\(albumId)", method: .GET)
        dependencies.httpClient.fetch(with: request) { result in
            guard case .success(let response) = result,
                let body = response.body else {
                    completion([])
                    return
            }

            do {
                let photoDTOs = try JSONDecoder().decode([PhotoDTO].self, from: body)
                completion(photoDTOs)
            } catch {
                completion([])
            }
        }
    }
}

extension AlbumRepository {
    final class Dependencies {
        let httpClient: HTTPClientProtocol
        let mapper: AlbumMapperProtocol

        init(httpClient: HTTPClientProtocol = HTTPClient(),
             mapper: AlbumMapperProtocol = AlbumMapper()) {
            self.httpClient = httpClient
            self.mapper = mapper
        }
    }
}
