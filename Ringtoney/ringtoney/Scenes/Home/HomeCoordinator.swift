//
//  HomeCoordinator.swift
//  ringtoney
//
//  Created by dong ka on 10/29/20.
//  Copyright (c) 2020 All rights reserved.
//

import Foundation
import UIKit

class HomeCoordinator: BaseCoordinator {
    
    let bag = DisposeBag()
    
    init(navigationController: UINavigationController?) {
        super.init()
        self.navigationController = navigationController
    }
    
    deinit {
        log.debug("\(type(of: self)): Deinited")
    }
    
    override func start() {
        let viewModel = HomeViewModel.init()
        viewModel.coordinator = self
        let viewController = HomeViewController.init(viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func openRingMaker( audioURL: URL ) {
        let makerModel = MakerModel.init()
        makerModel.audioPath = audioURL.path
        let coordinator = RingMakerCoordinator.init(navigationController: self.navigationController,
                                                    makerModel: makerModel)
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
