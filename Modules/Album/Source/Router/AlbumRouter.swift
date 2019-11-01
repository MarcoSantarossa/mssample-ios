import Core

public protocol AlbumRouterProtocol: AnyObject {
    func presentCollection()
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
}
