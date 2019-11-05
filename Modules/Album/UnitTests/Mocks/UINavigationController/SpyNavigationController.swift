import Core

final class SpyNavigationController: NavigationControllerProtocol {

    private(set) var setRootViewControllerCallsCount = 0
    private(set) var setRootViewControllerArg: UIViewController!

    private(set) var pushViewControllerCallsCount = 0
    private(set) var pushViewControllerArg: UIViewController!
    private(set) var pushViewControllerAnimatedArg: Bool!

    func setRootViewController(_ rootVC: UIViewController) {
        setRootViewControllerCallsCount += 1
        setRootViewControllerArg = rootVC
    }

    func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushViewControllerCallsCount += 1

        pushViewControllerArg = viewController
        pushViewControllerAnimatedArg = animated
    }
}
