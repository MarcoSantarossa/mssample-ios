protocol AlbumInteractorProtocol: AnyObject {
    func getAlbum(completion: @escaping (Album?) -> Void)
    func getPhoto(id: Int, completion: @escaping (Photo?) -> Void)
}

final class AlbumInteractor: AlbumInteractorProtocol {

    private let dependencies: Dependencies

    init(dependencies: Dependencies = .init()) {
        self.dependencies = dependencies
    }

    func getAlbum(completion: @escaping (Album?) -> Void) {
        dependencies.repo.getAlbum(completion: completion)
    }

    func getPhoto(id: Int, completion: @escaping (Photo?) -> Void) {
        dependencies.repo.getPhoto(id: id, completion: completion)
    }
}

extension AlbumInteractor {
    final class Dependencies {
        let repo: AlbumRepositoryProtocol

        init(repo: AlbumRepositoryProtocol = AlbumRepository()) {
            self.repo = repo
        }
    }
}
