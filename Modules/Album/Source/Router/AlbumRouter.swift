import Core

public protocol AlbumRouterProtocol: AnyObject {
    func presentCollection()
    func presentPhotoDetails(photoId: Int)
}

public final class AlbumRouter: AlbumRouterProtocol {

    private unowned let parent: NavigationControllerProtocol

    public init(parent: NavigationControllerProtocol) {
        self.parent = parent
    }

    public func presentCollection() {
        let viewController = PhotoCollectionViewController()
        parent.setRootViewController(viewController)
    }

    public func presentPhotoDetails(photoId: Int) {
        let presenter = PhotoDetailsPresenter(photoId: photoId)
        let viewController = PhotoDetailsViewController(presenter: presenter)
        parent.pushViewController(viewController, animated: true)
    }
}
