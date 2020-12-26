//
//  IntroACoordinator.swift
//  ringtoney
//
//  Created by dong ka on 28/11/2020.
//  Copyright (c) 2020 All rights reserved.
//

import Foundation
import UIKit

class IntroACoordinator: BaseCoordinator {
    
    let bag = DisposeBag()
    
    init(navigationController: UINavigationController?) {
        super.init()
        self.navigationController = navigationController
    }
    
    deinit {
        log.debug("\(type(of: self)): Deinited")
    }
    
    override func start() {
        let viewModel = IntroAViewModel.init()
        viewModel.coordinator = self
        let viewController = IntroAViewController.init(viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    func openIntroB() {
        let coordinator = IntroBCoordinator.init(navigationController: self.navigationController)
        store(coordinator: coordinator)
        coordinator.start()
        
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
