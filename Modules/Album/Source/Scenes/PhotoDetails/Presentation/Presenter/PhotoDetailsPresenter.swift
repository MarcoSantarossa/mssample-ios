final class PhotoDetailsPresenter: PhotoDetailsPresenterProtocol {

    var onDataDidUpdate: (() -> Void)?

    var photoTitle: String {
        return currentPhoto?.title ?? ""
    }

    var status: PhotoDetailsPresenterStatus = .loading {
        didSet {
            onDataDidUpdate?()
        }
    }

    private let dependencies: Dependencies
    private let photoId: Int
    private var currentPhoto: Photo? {
        didSet {
            status = currentPhoto == nil ? .dataNotFound : .dataAvailable
        }
    }

    init(photoId: Int, dependencies: Dependencies = .init()) {
        self.dependencies = dependencies
        self.photoId = photoId
    }

    func viewDidLoad() {
        dependencies.albumInteractor.getPhoto(id: photoId) { [weak self] photo in
            guard let self = self else { return }
            self.currentPhoto = photo
        }
    }

    func getImage(completion: @escaping (Data) -> Void) {
        guard let imageUrl = currentPhoto?.url else { return }

        dependencies.imageInteractor.getImage(at: imageUrl) { image in
            completion(image.data)
        }
    }
}

extension PhotoDetailsPresenter {
    final class Dependencies {
        let albumInteractor: AlbumInteractorProtocol
        let imageInteractor: ImageInteractorProtocol

        init(albumInteractor: AlbumInteractorProtocol = AlbumInteractor(),
             imageInteractor: ImageInteractorProtocol = ImageInteractor()) {
            self.albumInteractor = albumInteractor
            self.imageInteractor = imageInteractor
        }
    }
}