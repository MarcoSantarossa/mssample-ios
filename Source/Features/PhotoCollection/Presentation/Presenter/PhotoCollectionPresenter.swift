import Foundation

final class PhotoCollectionPresenter: PhotoCollectionPresenterProtocol {
    var itemsCount: Int {
        return items.count
    }
    var onDataDidUpdate: (() -> Void)?

    private let dependencies: Dependencies
    private var items = [PhotoCollectionItem]()

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

    func startLoadImage(at index: Int, completion: (Data) -> Void) {

    }

    func cancelLoadImage(at index: Int) {

    }

    func title(at index: Int) -> String {
        guard index < items.count else { return "" }

        return items[index].title
    }
}

extension PhotoCollectionPresenter {
    final class Dependencies {
        let interactor: PhotoCollectionInteractorProtocol

        init(interactor: PhotoCollectionInteractorProtocol = PhotoCollectionInteractor()) {
            self.interactor = interactor
        }
    }
}
