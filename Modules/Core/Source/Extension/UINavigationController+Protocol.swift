import UIKit

public protocol NavigationControllerProtocol: AnyObject {
    func setRootViewController(_ rootVC: UIViewController)
    func pushViewController(_ viewController: UIViewController, animated: Bool)
}

extension UINavigationController: NavigationControllerProtocol {
    public func setRootViewController(_ rootVC: UIViewController) {
        setViewControllers([rootVC], animated: false)
    }
}
