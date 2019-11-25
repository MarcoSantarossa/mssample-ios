import Core

final class PhotoCollectionPresenter: PhotoCollectionPresenterProtocol {

    var onStateDidChange: ((PhotoCollectionPresenterState) -> Void)?
    var onImageDidLoad: ((_ index: Int, _ image: Data) -> Void)?

    var state: PhotoCollectionPresenterState = .loading {
        didSet {
            onStateDidChange?(state)
        }
    }

    var itemsCount: Int {
        return album?.photos.count ?? 0
    }

    var albumTitle: String {
        return album?.title ?? ""
    }

    private let dependencies: Dependencies
    private var album: Album? {
        didSet {
            state = album == nil ? .dataNotFound : .dataAvailable
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

    func title(at index: Int) -> String {
        guard let album = album, album.photos.count > index else { return "" }
        return album.photos[index].title.capitalized
    }

    func photoId(at index: Int) -> Int {
        guard let album = album, album.photos.count > index else { return -1 }
        return album.photos[index].id
    }

    func itemDidShow(at index: Int) {
        guard let album = album, album.photos.count > index else { return }

        let imageInteractor = dependencies.imageInteractorType.init()
        queue[index] = imageInteractor

        imageInteractor.getImage(at: album.photos[index].thumbnailUrl) { [weak self] image in
            self?.onImageDidLoad?(index, image.data)
        }
    }

    func itemDidHide(at index: Int) {
        guard let interactor = queue[index] else { return }
        interactor.cancel()

        queue[index] = nil
    }
}

extension PhotoCollectionPresenter {
    final class Dependencies {
        let interactor: AlbumInteractorProtocol
        let imageInteractorType: ImageInteractorProtocol.Type

        init(interactor: AlbumInteractorProtocol = AlbumInteractor(),
             imageInteractorType: ImageInteractorProtocol.Type = ImageInteractor.self) {
            self.interactor = interactor
            self.imageInteractorType = imageInteractorType
        }
    }
}
