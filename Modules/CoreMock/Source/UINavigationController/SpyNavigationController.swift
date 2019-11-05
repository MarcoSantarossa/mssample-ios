import Core

public final class SpyNavigationController: NavigationControllerProtocol {

    public private(set) var setRootViewControllerCallsCount = 0
    public private(set) var setRootViewControllerArg: UIViewController!

    public private(set) var pushViewControllerCallsCount = 0
    public private(set) var pushViewControllerArg: UIViewController!
    public private(set) var pushViewControllerAnimatedArg: Bool!

    public init() {}

    public func setRootViewController(_ rootVC: UIViewController) {
        setRootViewControllerCallsCount += 1
        setRootViewControllerArg = rootVC
    }

    public func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushViewControllerCallsCount += 1

        pushViewControllerArg = viewController
        pushViewControllerAnimatedArg = animated
    }
}
