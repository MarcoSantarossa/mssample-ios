import UIKit

final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let navController = UINavigationController(rootViewController: PhotoCollectionViewController())

        window = UIWindow()
        window?.rootViewController = navController
        window?.makeKeyAndVisible()

        return true
    }

}
