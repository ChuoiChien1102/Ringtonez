//
//  BootCoordinator.swift
//  ringtoney
//
//  Created by dong ka on 28/11/2020.
//  Copyright (c) 2020 All rights reserved.
//

import Foundation
import UIKit

protocol BootUpdate {
    func openMainCoordinator()
}



class BootCoordinator: BaseCoordinator {
    
    let bag = DisposeBag()
    
    init(navigationController: UINavigationController?) {
        super.init()
        self.navigationController = navigationController
        Broadcaster.register(BootUpdate.self, observer: self)
    }
    
    deinit {
        log.debug("\(type(of: self)): Deinited")
    }
    
    override func start() {
        let viewModel = BootViewModel.init()
        viewModel.coordinator = self
        let viewController = BootViewController.init(viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    func openIntroA() {
        
        let coordinator = IntroACoordinator.init(navigationController: self.navigationController)
        store(coordinator: coordinator)
        coordinator.start()
        
        coordinator.onCompleted = {[weak self] in
            guard let self = self else { return }
            self.free(coordinator: coordinator)
        }
    }
    
    
    func openMain() {
        let coordinator = MainTabbarCoordinator.init(navigationController: self.navigationController)
        store(coordinator: coordinator)
        coordinator.start()
        
        let app = UIApplication.shared.delegate as! AppDelegate

        app.window?.rootViewController = coordinator.tabbarController
        app.window?.makeKeyAndVisible()
        
        coordinator.onCompleted = {[weak self] in
            guard let self = self else { return }
            self.free(coordinator: coordinator)
        }
    }
    
   override func openPremium() {
        
        let coordinator = PremiumCCoordinator.init(navigationController: self.navigationController!)
        store(coordinator: coordinator)
        coordinator.start()
        
        coordinator.onDidClose = {[weak self] in
            guard let self = self else { return }
            self.openMain()
        }
    
        coordinator.onCompleted = {[weak self] in
            guard let self = self else { return }
            self.free(coordinator: coordinator)
        }
    }

}

extension BootCoordinator: BootUpdate {
  
    func openMainCoordinator() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.openMain()
        }
    }
    
    
}
