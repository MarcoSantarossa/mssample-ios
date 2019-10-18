import Foundation

protocol ImageInteractorProtocol: AnyObject {
    func getImage(at url: String, completion: @escaping (Image?) -> Void)

    func cancel()
}

final class ImageInteractor: ImageInteractorProtocol {

    private let dependencies: Dependencies

    init(dependencies: Dependencies = .init()) {
        self.dependencies = dependencies
    }

    func getImage(at url: String, completion: @escaping (Image?) -> Void) {
        dependencies.repo.getImage(at: url, completion: completion)
    }

    func cancel() {
        dependencies.repo.cancel()
    }
}

extension ImageInteractor {
    final class Dependencies {
        let repo: ImageRepositoryProtocol

        init(repo: ImageRepositoryProtocol = ImageRepository()) {
            self.repo = repo
        }
    }
}
