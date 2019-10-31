import Core

protocol PhotoFlowProtocol: AnyObject {
    func presentCollection()
}

final class PhotoFlow: PhotoFlowProtocol {

    private unowned let parent: NavigationControllerProtocol

    init(parent: NavigationControllerProtocol) {
        self.parent = parent
    }

    func presentCollection() {
        let viewController = PhotoCollectionViewController()
        parent.setRootViewController(viewController)
    }
}
