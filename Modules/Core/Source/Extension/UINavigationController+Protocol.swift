import UIKit

public protocol NavigationControllerProtocol: AnyObject {
    func setRootViewController(_ rootVC: ViewControllerProtocol)
}

extension UINavigationController: NavigationControllerProtocol {
    public func setRootViewController(_ rootVC: ViewControllerProtocol) {
        setViewControllers([rootVC as! UIViewController], animated: false)
    }
}
