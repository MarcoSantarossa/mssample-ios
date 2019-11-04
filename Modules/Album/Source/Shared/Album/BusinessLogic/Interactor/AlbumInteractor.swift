protocol AlbumInteractorProtocol: AnyObject {
    func getAlbum(completion: @escaping (Album?) -> Void)
}

final class AlbumInteractor: AlbumInteractorProtocol {

    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func getAlbum(completion: @escaping (Album?) -> Void) {
        dependencies.repo.getAlbum(completion: completion)
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
