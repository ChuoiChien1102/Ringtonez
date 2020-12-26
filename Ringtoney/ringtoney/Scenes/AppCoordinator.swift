//
//  AppCoordinator.swift
//  ringtoney
//
//  Created by dong ka on 10/29/20.
//

import Foundation
import UIKit
import SwiftNotificationCenter

protocol AppCoordinatorProtocol {
//    func openMain()
//    func openSignin()
}

final class AppCoordinator : BaseCoordinator {

    let window: UIWindow
        
    init(window: UIWindow) {
        self.window = window
        super.init()
        Broadcaster.register(AppCoordinatorProtocol.self, observer: self)
    }
    
    override func start() {
        
        let nav = UINavigationController.init()
        self.navigationController = nav
        
        let coordinator = BootCoordinator.init(navigationController: self.navigationController)
        store(coordinator: coordinator)
        coordinator.start()

        //Window
        window.rootViewController = coordinator.navigationController
        window.makeKeyAndVisible()
     }

}

extension AppCoordinator : AppCoordinatorProtocol {

}
