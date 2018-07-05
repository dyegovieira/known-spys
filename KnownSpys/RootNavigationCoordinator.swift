//
//  NavigationCoordinator.swift
//  KnownSpys
//
//  Created by Jon Bott on 4/20/17.
//  Copyright © 2017 JonBott.com. All rights reserved.
//

import UIKit

protocol NavigationCoordinator: class {
    init(with modelLayer: ModelLayer, in window: UIWindow?)
    
    func next(arguments: Dictionary<String, Any>?)
    func movingBack()
}

enum NavigationState {
    case atSpyList,
         atSpyDetails,
         atSecretDetails,
         inSignupProcess
}

class RootNavigationCoordinatorImpl: NavigationCoordinator {
    
    private var navigationController: UINavigationController
    private var modelLayer: ModelLayer
    
    var navState: NavigationState = .atSpyList
    
    required init(with modelLayer: ModelLayer, in window: UIWindow?) {
        self.modelLayer = modelLayer
        navigationController = UINavigationController()
        navigationController.viewControllers = []
        window?.rootViewController = navigationController
        
        showSpyList()
    }
    
    func movingBack() {
        switch navState {
        case .atSpyList: //not possible to move back - do nothing
            break
        case .atSpyDetails:
            navState = .atSpyList
        case .atSecretDetails:
            navState = .atSpyDetails
        case .inSignupProcess: //example - do nothing
            break
        }
    }
    
    func next(arguments: Dictionary<String, Any>?) {
        switch navState {
        case .atSpyList:
            showDetails(arguments: arguments)
        case .atSpyDetails:
            showSecretDetails(arguments: arguments)
        case .atSecretDetails:
            showSpyList()
        case .inSignupProcess: //example - do nothing
            break
        }
    }
    
    func showSpyList() {
        if navigationController.viewControllers.count > 0 {
            navigationController.popToRootViewController(animated: true)
            return
        }
        
        let presenter = SpyListPresenterImpl(modelLayer: modelLayer)
        let listViewController = SpyListViewController(with: presenter, navigationCoordinator: self)
        
        navigationController.viewControllers = [listViewController]
        navState = .atSpyList
    }
    
    func showDetails(arguments: Dictionary<String, Any>?) {
        if navState == .atSpyDetails {
            return
        }
        
        guard let spy = arguments?["spy"] as? SpyDTO else { notifyNilArguments(); return }
        
        let presenter = DetailPresenterImpl(with: spy)
        let detailViewController = DetailViewController(with: presenter, navigationCoordinator: self)
        
        navigationController.pushViewController(detailViewController, animated: true)
        navState = .atSpyDetails
    }
    
    func showSecretDetails(arguments: Dictionary<String, Any>?) {
        guard let spy = arguments?["spy"] as? SpyDTO else { notifyNilArguments(); return }

        let presenter = SecretDetailsPresenterImpl(with: spy)
        let secretDetailViewController = SecretDetailsViewController(with: presenter, navigationCoordinator: self)
        
        navigationController.pushViewController(secretDetailViewController, animated: true)
        navState = .atSecretDetails
    }
    
    func notifyNilArguments() {
        print("notify user of error")
    }
}
