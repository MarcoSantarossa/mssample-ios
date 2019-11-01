protocol PhotoCollectionInteractorProtocol: AnyObject {
    func getPhotos(completion: @escaping ([PhotoCollectionItem]) -> Void)
}

final class PhotoCollectionInteractor: PhotoCollectionInteractorProtocol {

    private let dependencies: Dependencies

    init(dependencies: Dependencies = .init()) {
        self.dependencies = dependencies
    }

    func getPhotos(completion: @escaping ([PhotoCollectionItem]) -> Void) {
        dependencies.repo.getPhotos(completion: completion)
    }
}

extension PhotoCollectionInteractor {
    final class Dependencies {
        let repo: PhotoCollectionRepositoryProtocol

        init(repo: PhotoCollectionRepositoryProtocol = PhotoCollectionRepository()) {
            self.repo = repo
        }
    }
}
