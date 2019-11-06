import Core

final class PhotoCollectionPresenter: PhotoCollectionPresenterProtocol {
    var itemsCount: Int {
        return album?.photos.count ?? 0
    }
    var onDataDidUpdate: (() -> Void)?

    var mainTitle: String {
        guard let albumTitle = album?.title else {
            return AlbumLocalizable.localize(key: .photoCollectionTitleNotAvailable, localizer: dependencies.localizer)
        }
        return String(format: AlbumLocalizable.localize(key: .photoCollectionTitle, localizer: dependencies.localizer), albumTitle)
    }

    private let dependencies: Dependencies
    private var album: Album? {
        didSet {
            self.onDataDidUpdate?()
        }
    }
    private var queue = [Int: ImageInteractorProtocol]()

    init(dependencies: Dependencies = .init()) {
        self.dependencies = dependencies
    }

    func viewDidLoad() {
        fetchPhotos()
    }

    private func fetchPhotos() {
        dependencies.interactor.getAlbum { [weak self] album in
            guard let self = self else { return }

            self.album = album
        }
    }

    func startLoadImage(at index: Int, completion: @escaping (Data) -> Void) {
        guard let album = album, queue[index] == nil && index < album.photos.count else { return }

        let imageInteractor = dependencies.imageInteractorType.init()
        queue[index] = imageInteractor

        imageInteractor.getImage(at: album.photos[index].thumbnailUrl) { image in
            completion(image.data)
        }
    }

    func cancelLoadImage(at index: Int) {
        guard let interactor = queue[index] else { return }
        interactor.cancel()

        queue[index] = nil
    }

    func title(at index: Int) -> String {
        guard let album = album, album.photos.count > index else { return "" }
        return album.photos[index].title.capitalized
    }

    func photoId(at index: Int) -> Int {
        guard let album = album, album.photos.count > index else { return -1 }
        return album.photos[index].id
    }
}

extension PhotoCollectionPresenter {
    final class Dependencies {
        let interactor: AlbumInteractorProtocol
        let imageInteractorType: ImageInteractorProtocol.Type
        let localizer: LocalizerProtocol

        init(interactor: AlbumInteractorProtocol = AlbumInteractor(),
             imageInteractorType: ImageInteractorProtocol.Type = ImageInteractor.self,
             localizer: LocalizerProtocol = Localizer()) {
            self.interactor = interactor
            self.imageInteractorType = imageInteractorType
            self.localizer = localizer
        }
    }
}
