//
//  SearchDetailCoordinator.swift
//  ringtoney
//
//  Created by dong ka on 11/10/20.
//  Copyright (c) 2020 All rights reserved.
//

import Foundation
import UIKit

class SearchDetailCoordinator: BaseCoordinator {
    
    let bag = DisposeBag()
    var searchString : String = ""
    
    init(navigationController: UINavigationController?) {
        super.init()
        self.navigationController = navigationController
    }
    
    init(navigationController: UINavigationController?, searchString: String) {
        super.init()
        self.navigationController = navigationController
        self.searchString = searchString
    }
    
    deinit {
        log.debug("\(type(of: self)): Deinited")
    }
    
    override func start() {
        let viewModel = SearchDetailViewModel.init(searchString: self.searchString)
        viewModel.coordinator = self
        let viewController = SearchDetailViewController.init(viewModel: viewModel)
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
