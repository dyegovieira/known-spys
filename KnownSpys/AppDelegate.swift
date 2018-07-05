import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigationCoordinator: NavigationCoordinator!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        MockedWebServer.sharedInstance.start()
        
        let networkLayer = NetworkLayerImpl()
        let dataLayer = DataLayerImpl()
        let spyTranslator = SpyTranslatorImpl()
        let translateLayer = TranslationLayerImpl(spyTranslator: spyTranslator)
        let modelLayer = ModelLayerImpl(
            networkLayer: networkLayer,
            dataLayer: dataLayer,
            translationLayer: translateLayer
        )
        
        navigationCoordinator = RootNavigationCoordinatorImpl(
            with: modelLayer, in: window)
        
        return true
    }
}

