//
//  PremiumBaseCoordinator.swift
//  ringtoney
//
//  Created by dong ka on 24/11/2020.
//  Copyright (c) 2020 All rights reserved.
//

import Foundation
import UIKit

class PremiumBaseCoordinator: BaseCoordinator {
    
    let bag = DisposeBag()
    
    init(navigationController: UINavigationController?) {
        super.init()
        self.navigationController = navigationController
    }
    
    deinit {
        log.debug("\(type(of: self)): Deinited")
    }
    
    override func start() {
        let viewModel = PremiumBaseViewModel.init()
        viewModel.coordinator = self
        let viewController = PremiumBaseViewController.init(viewModel: viewModel)
        viewController.modalPresentationStyle = .fullScreen
        navigationController?.present(viewController, animated: true, completion: nil)
    }
    
    func pop() {
        self.navigationController?.popViewController(animated: true)
        self.onCompleted?()
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
