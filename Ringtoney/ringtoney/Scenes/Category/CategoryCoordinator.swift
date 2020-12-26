//
//  CategoryCoordinator.swift
//  ringtoney
//
//  Created by dong ka on 11/2/20.
//  Copyright (c) 2020 All rights reserved.
//

import Foundation
import UIKit

class CategoryCoordinator: BaseCoordinator {
    
    let bag = DisposeBag()
    
    init(navigationController: UINavigationController?) {
        super.init()
        self.navigationController = navigationController
    }
    
    deinit {
        log.debug("\(type(of: self)): Deinited")
    }
    
    override func start() {
        let viewModel = CategoryViewModel.init()
        viewModel.coordinator = self
        let viewController = CategoryViewController.init(viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func openCategoryDetail(_ category: Category?) {
        
        let coordinator = CategoryDetailCoordinator.init(
            navigationController: self.navigationController,
            category: category
        )
        store(coordinator: coordinator)
        coordinator.start()
        
        coordinator.onCompleted = {[weak self] in
            guard let self = self else { return }
            self.free(coordinator: coordinator)
        }
    }
    
    func openSearchDetail(_ searchString: String) {
        
        let coordinator = SearchDetailCoordinator.init(navigationController: self.navigationController, searchString: searchString)
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
