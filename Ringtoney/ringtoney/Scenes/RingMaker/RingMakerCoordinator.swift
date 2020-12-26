//
//  RingMakerCoordinator.swift
//  ringtoney
//
//  Created by dong ka on 11/12/20.
//  Copyright (c) 2020 All rights reserved.
//

import Foundation
import UIKit

class RingMakerCoordinator: BaseCoordinator {
    
    let bag = DisposeBag()
    var makerModel: MakerModel!

    init(navigationController: UINavigationController?) {
        super.init()
        self.navigationController = navigationController
    }
    
    init(navigationController: UINavigationController?, makerModel: MakerModel) {
        super.init()
        self.navigationController = navigationController
        self.makerModel = makerModel
    }
    
    deinit {
        log.debug("\(type(of: self)): Deinited")
    }
    
    override func start() {
        let viewModel = RingMakerViewModel.init(makerModel: self.makerModel)
        viewModel.coordinator = self
        let viewController = RingMakerViewController.init(viewModel: viewModel)
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
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
