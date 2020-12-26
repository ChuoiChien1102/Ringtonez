//
//  IntroBCoordinator.swift
//  ringtoney
//
//  Created by dong ka on 28/11/2020.
//  Copyright (c) 2020 All rights reserved.
//

import Foundation
import UIKit

class IntroBCoordinator: BaseCoordinator {
    
    let bag = DisposeBag()
    
    init(navigationController: UINavigationController?) {
        super.init()
        self.navigationController = navigationController
    }
    
    deinit {
        log.debug("\(type(of: self)): Deinited")
    }
    
    override func start() {
        let viewModel = IntroBViewModel.init()
        viewModel.coordinator = self
        let viewController = IntroBViewController.init(viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func openPremiumA() {
        let coordinator = PremiumCCoordinator.init(navigationController: self.navigationController)
        store(coordinator: coordinator)
        coordinator.start()
        
        coordinator.onDidClose = {
            self.navigationController?.popToRootViewController(animated: true)
            Broadcaster.notify(BootUpdate.self) {
                $0.openMainCoordinator()
            }
        }
        
        coordinator.onCompleted = {[weak self] in
            guard let self = self else { return }
            self.free(coordinator: coordinator)
        }
    }
    
    /*
    private func openSomeScenes() {
        let coordinator = ReportCoordinator.init(navigationController: self.navigationController)
        store(coordinator: coordinator)
        coordinator.start()
        
        coordinator.onCompleted = {[weak self] in
            guard let self = self else { return }
            self.free(coordinator: coordinator)
        }
        
    }
     **/
    
}
