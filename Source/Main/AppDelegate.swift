import Album
import Core

final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var mainRouter: AlbumRouter?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let navController = UINavigationController()
        startMainRouting(in: navController)

        window = presentNewMainWindow(root: navController)

        return true
    }

    private func startMainRouting(in parent: NavigationControllerProtocol) {
        let router = AlbumRouter(parent: parent)
        router.presentCollection()

        self.mainRouter = router
    }

    private func presentNewMainWindow(root: UINavigationController) -> UIWindow {
        let window = UIWindow()
        window.rootViewController = root
        window.makeKeyAndVisible()
        return window
    }
}
