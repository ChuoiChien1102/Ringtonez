//
//  MytoneCoordinator.swift
//  ringtoney
//
//  Created by dong ka on 11/2/20.
//  Copyright (c) 2020 All rights reserved.
//

import Foundation
import UIKit

class MytoneCoordinator: BaseCoordinator {
    
    let bag = DisposeBag()
    
    init(navigationController: UINavigationController?) {
        super.init()
        self.navigationController = navigationController
    }
    
    deinit {
        log.debug("\(type(of: self)): Deinited")
    }
    
    override func start() {
        let viewModel = MytoneViewModel.init()
        viewModel.coordinator = self
        let viewController = MytoneViewController.init(viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func openRecord() {
        let coordinator = RecordCoordinator.init(navigationController: self.navigationController)
        store(coordinator: coordinator)
        coordinator.start()
        
        coordinator.onCompleted = {[weak self] in
            guard let self = self else { return }
            self.free(coordinator: coordinator)
        }
        
    }
    
    func openMaker(audioURL: URL) {
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
