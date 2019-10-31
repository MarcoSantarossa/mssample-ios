import UIKit

protocol NavigationControllerProtocol: AnyObject {
    func setRootViewController(_ rootVC: ViewControllerProtocol)
}

extension UINavigationController: NavigationControllerProtocol {
    func setRootViewController(_ rootVC: ViewControllerProtocol) {
        setViewControllers([rootVC as! UIViewController], animated: false)
    }
}
