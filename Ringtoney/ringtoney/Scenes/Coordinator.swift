//
//  Coordinator.swift
//  ringtoney
//
//  Created by dong ka on 10/29/20.
//

import Foundation
import UIKit
import SafariServices
import AFDateHelper

protocol Coordinator: class {
    
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController? { get set}
    var rootViewController: UIViewController? { get set }
    
    func start()
    
}

extension Coordinator {
    
    func store( coordinator: Coordinator) {
        log.debug("Store Coordinator: \(type(of: coordinator))")
        childCoordinators.append(coordinator)
    }
    
    func free( coordinator: Coordinator) {
        log.debug("Free Coordinator: \(type(of: coordinator))")
        childCoordinators = childCoordinators.filter({$0 !== coordinator })
    }
    
}


class BaseCoordinator : Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController?
    var rootViewController: UIViewController?
    
    var onCompleted: (() -> Void)?
    
    func start() {
        fatalError("Children shold implement `start`")
    }
    
    deinit {
        log.debug("\(type(of: self)): Deinited")
    }
    
    func openPremiumB() {
        
        func openPlanB() {
            let coordinator = PremiumBCoordinator.init(navigationController: self.navigationController!)
            store(coordinator: coordinator)
            coordinator.start()
            
            coordinator.onCompleted = {[weak self] in
                guard let self = self else { return }
                self.free(coordinator: coordinator)
            }
        }
        
//        if let startDate = Defaults[\.startSaleDate] {
//            let secondsSince = Date().since(startDate, in: .second)
//            log.debug("secondsSince: \(secondsSince)")
//            if secondsSince < Configs.DefaultValue.litmitOffer {
//                self.openFlashSale()
//            } else {
//                openPlanB()
//            }
//        } else {
            openPlanB()
//        }
    }
    
    func openFlashSale() {
        let coordinator = PremiumACoordinator.init(navigationController: self.navigationController!)
        store(coordinator: coordinator)
        coordinator.start()
        
        coordinator.onCompleted = {[weak self] in
            guard let self = self else { return }
            self.free(coordinator: coordinator)
        }
    }
    
    func openPremium() {
        
        let coordinator = PremiumCCoordinator.init(navigationController: self.navigationController!)
        store(coordinator: coordinator)
        coordinator.start()
        
        coordinator.onCompleted = {[weak self] in
            guard let self = self else { return }
            self.free(coordinator: coordinator)
        }
    }
    
    func openTermOfUse() {
        DispatchQueue.main.async {
            log.debug("Open term of use")
            if let url = URL(string: Configs.App.termOfUse) {
                let config = SFSafariViewController.Configuration()
                config.entersReaderIfAvailable = true
                let vc = SFSafariViewController(url: url, configuration: config)
                self.rootViewController?.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    func openTutorial() {
        let coordinator = TutorialCoordinator.init(navigationController: self.navigationController)
        store(coordinator: coordinator)
        coordinator.start()
        
        coordinator.onCompleted = {[weak self] in
            guard let self = self else { return }
            self.free(coordinator: coordinator)
        }
    }
    
    
}
