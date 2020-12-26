//
//  TutorialCoordinator.swift
//  ringtoney
//
//  Created by dong ka on 03/12/2020.
//  Copyright (c) 2020 All rights reserved.
//

import Foundation
import UIKit

class TutorialCoordinator: BaseCoordinator {
    
    let bag = DisposeBag()
    
    init(navigationController: UINavigationController?) {
        super.init()
        self.navigationController = navigationController
    }
    
    deinit {
        log.debug("\(type(of: self)): Deinited")
    }
    
    override func start() {
        let viewModel = TutorialViewModel.init()
        viewModel.coordinator = self
        let viewController = TutorialViewController.init(viewModel: viewModel)
        navigationController?.present(viewController, animated: true, completion: nil)
    }
    
    func pop() {
        self.navigationController?.dismiss(animated: true, completion: nil)
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
