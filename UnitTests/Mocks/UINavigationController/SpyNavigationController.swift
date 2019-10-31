@testable import MSSampleiOS

final class SpyNavigationController: NavigationControllerProtocol {

    private(set) var setRootViewControllerCallsCount = 0
    private(set) var setRootViewControllerArg: ViewControllerProtocol!

    func setRootViewController(_ rootVC: ViewControllerProtocol) {
        setRootViewControllerCallsCount += 1
        setRootViewControllerArg = rootVC
    }
}
