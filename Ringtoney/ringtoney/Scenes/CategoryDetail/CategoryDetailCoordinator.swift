//
//  CategoryDetailCoordinator.swift
//  ringtoney
//
//  Created by dong ka on 11/8/20.
//  Copyright (c) 2020 All rights reserved.
//

import Foundation
import UIKit

class CategoryDetailCoordinator: BaseCoordinator {
    
    let bag = DisposeBag()
    var category: Category?
    
    init(navigationController: UINavigationController?) {
        super.init()
        self.navigationController = navigationController
    }
    
    init(navigationController: UINavigationController?, category: Category?) {
        super.init()
        self.category = category
        self.navigationController = navigationController
    }
    
    deinit {
        log.debug("\(type(of: self)): Deinited")
    }
    
    override func start() {
        let viewModel = CategoryDetailViewModel.init(category: self.category)
        viewModel.coordinator = self
        let viewController = CategoryDetailViewController.init(viewModel: viewModel)
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
