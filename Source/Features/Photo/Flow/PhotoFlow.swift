import UIKit

final class PhotoFlow {

    private unowned let parent: NavigationControllerProtocol

    init(parent: NavigationControllerProtocol) {
        self.parent = parent
    }

    func presentCollection() {
        let viewController = PhotoCollectionViewController()
        parent.setRootViewController(viewController)
    }
}
