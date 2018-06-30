import UIKit
import Swinject
import SwinjectStoryboard

// This enables injection of the initial view controller from the app's main
//   storyboard project settings. So, this is the starting point of the
//   dependency tree.
extension SwinjectStoryboard {
    public class func setup() {
        if AppDelegate.dependencyRegistry == nil {
            AppDelegate.dependencyRegistry = DependencyRegistryImpl(container: defaultContainer)
        }
        
        let dependencyRegistry: DependencyRegistry = AppDelegate.dependencyRegistry
        
        func main() {
            dependencyRegistry.container.storyboardInitCompleted(SpyListViewController.self) { r, vc in
                
                let coordinator = dependencyRegistry.makeRootNavigationCoordinator(rootViewController: vc)
                
                setupData(resolver: r, navigationCoordinator: coordinator)
                
                let presenter = r.resolve(SpyListPresenter.self)!
                
                //NOTE: We don't have access to the constructor for this VC so we are using method injection
                vc.configure(with: presenter,
            navigationCoordinator: coordinator,
                     spyCellMaker: dependencyRegistry.makeSpyCell)
            }
        }
        
        func setupData(resolver r: Resolver, navigationCoordinator: NavigationCoordinator) {
            MockedWebServer.sharedInstance.start()
            AppDelegate.navigationCoordinator = navigationCoordinator
        }
        
        main()
    }
}
