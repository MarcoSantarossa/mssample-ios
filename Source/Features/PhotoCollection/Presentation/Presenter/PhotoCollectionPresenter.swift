import Foundation

final class PhotoCollectionPresenter: PhotoCollectionPresenterProtocol {
    var itemsCount: Int {
        return items.count
    }
    var onDataDidUpdate: (() -> Void)?

    private let dependencies: Dependencies
    private var items = [PhotoCollectionItem]()
    private var queue = [Int: ImageInteractorProtocol]()

    init(dependencies: Dependencies = .init()) {
        self.dependencies = dependencies
    }

    func viewDidLoad() {
        dependencies.interactor.getPhotos { [weak self] items in
            guard let self = self else { return }

            self.items = items
            self.onDataDidUpdate?()
        }
    }

    func startLoadImage(at index: Int, completion: @escaping (Data) -> Void) {
        guard queue[index] == nil && index < items.count else { return }

        let imageInteractor = dependencies.imageInteractorType.init()
        queue[index] = imageInteractor

        imageInteractor.getImage(at: items[index].thumbnailUrl) { image in
            completion(image.data)
        }
    }

    func cancelLoadImage(at index: Int) {
        guard let interactor = queue[index] else { return }
        interactor.cancel()

        queue[index] = nil
    }

    func title(at index: Int) -> String {
        guard index < items.count else { return "" }

        return items[index].title
    }
}

extension PhotoCollectionPresenter {
    final class Dependencies {
        let interactor: PhotoCollectionInteractorProtocol
        let imageInteractorType: ImageInteractorProtocol.Type

        init(interactor: PhotoCollectionInteractorProtocol = PhotoCollectionInteractor(),
             imageInteractorType: ImageInteractorProtocol.Type = ImageInteractor.self) {
            self.interactor = interactor
            self.imageInteractorType = imageInteractorType
        }
    }
}
