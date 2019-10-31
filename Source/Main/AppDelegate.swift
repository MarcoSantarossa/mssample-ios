import Core

final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let navController = UINavigationController()
        startMainFlow(in: navController)

        window = presentNewMainWindow(root: navController)

        return true
    }

    private func startMainFlow(in parent: NavigationControllerProtocol) {
        let mainFlow = PhotoFlow(parent: parent)
        mainFlow.presentCollection()
    }

    private func presentNewMainWindow(root: UINavigationController) -> UIWindow {
        let window = UIWindow()
        window.rootViewController = root
        window.makeKeyAndVisible()
        return window
    }
}
