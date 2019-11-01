import Core

public protocol PhotoFlowProtocol: AnyObject {
    func presentCollection()
}

public final class PhotoFlow: PhotoFlowProtocol {

    private unowned let parent: NavigationControllerProtocol

    public init(parent: NavigationControllerProtocol) {
        self.parent = parent
    }

    public func presentCollection() {
        let viewController = PhotoCollectionViewController()
        parent.setRootViewController(viewController)
    }
}
