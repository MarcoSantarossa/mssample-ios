import Album
import Core

final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let navController = UINavigationController()
        startMainRouting(in: navController)

        window = presentNewMainWindow(root: navController)

        return true
    }

    private func startMainRouting(in parent: NavigationControllerProtocol) {
        let mainRouter = AlbumRouter(parent: parent)
        mainRouter.presentPhotoDetails(photoId: 1)
    }

    private func presentNewMainWindow(root: UINavigationController) -> UIWindow {
        let window = UIWindow()
        window.rootViewController = root
        window.makeKeyAndVisible()
        return window
    }
}
