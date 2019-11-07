final class PhotoDetailsPresenter: PhotoDetailsPresenterProtocol {

    var onStateDidChange: ((PhotoDetailsPresenterState) -> Void)?

    var photoTitle: String {
        return currentPhoto?.title ?? ""
    }

    var state: PhotoDetailsPresenterState = .loading {
        didSet {
            onStateDidChange?(state)
        }
    }

    private let dependencies: Dependencies
    private let photoId: Int
    private var currentPhoto: Photo? {
        didSet {
            state = currentPhoto == nil ? .dataNotFound : .dataAvailable
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
