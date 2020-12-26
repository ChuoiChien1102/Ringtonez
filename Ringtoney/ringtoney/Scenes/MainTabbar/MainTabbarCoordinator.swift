//
//  MainTabbarCoordinator.swift
//  ringtoney
//
//  Created by dong ka on 11/2/20.
//  Copyright (c) 2020 All rights reserved.
//

import Foundation
import UIKit

protocol MainTabbarUpdate {
    func openRingtoneCatalog()
}

class MainTabbarCoordinator: BaseCoordinator {
    
    var tabbarController: UITabBarController

    let bag = DisposeBag()
    
    init(navigationController: UINavigationController?) {
        tabbarController = UITabBarController.init()
        super.init()
        self.navigationController = navigationController
    }
    
    override init() {
        tabbarController = UITabBarController.init()
        super.init()
        
        themeService.rx
            .bind({ $0.backgroundColor }, to: tabbarController.view.rx.backgroundColor)
    }
    
    deinit {
        log.debug("\(type(of: self)): Deinited")
    }
    
    override func start() {
        
        Broadcaster.register(MainTabbarUpdate.self, observer: self)

        var controllers: [UIViewController] = []

        //Home
        let homeCoordinator = HomeCoordinator.init(navigationController: UINavigationController.init())
        store(coordinator: homeCoordinator)
        homeCoordinator.start()
        
        let homeViewController = homeCoordinator.navigationController
        homeViewController?.tabBarItem = UITabBarItem.init(title: "", image: R.image.icon_tabbar_home_unselected(), tag: 0)
        
        //Categories
        let categoryCoordinator = CategoryCoordinator.init(navigationController: UINavigationController.init())
        store(coordinator: categoryCoordinator)
        categoryCoordinator.start()
        
        let categoryViewController = categoryCoordinator.navigationController
        categoryViewController?.tabBarItem = UITabBarItem.init(title: "", image: R.image.icon_tabbar_category_unselected(), tag: 1)
        
        //Mytone
        let mytoneCoordinator = MytoneCoordinator.init(navigationController: UINavigationController.init())
        store(coordinator: mytoneCoordinator)
        mytoneCoordinator.start()
        
        let mytoneViewController = mytoneCoordinator.navigationController
        mytoneViewController?.tabBarItem = UITabBarItem.init(title: "", image: R.image.icon_tabbar_mytone_unselected(), tag: 2)
        
        //Setting
        let settingsCoordinator = SettingCoordinator.init(navigationController: UINavigationController.init())
        store(coordinator: settingsCoordinator)
        settingsCoordinator.start()
        
        let settingViewController = settingsCoordinator.navigationController
        settingViewController?.tabBarItem = UITabBarItem.init(title: "", image: R.image.icon_tabbar_setting_unselected(), tag: 3)
                
        //Tabbar Controller
        controllers.append(homeViewController!)
        controllers.append(categoryViewController!)
        controllers.append(mytoneViewController!)
        controllers.append(settingViewController!)
        
        tabbarController.viewControllers = controllers
        tabbarController.tabBar.isTranslucent = false
        
        tabbarController.tabBar.items?[0].selectedImage = R.image.icon_tabbar_home_selected()
        tabbarController.tabBar.items?[1].selectedImage = R.image.icon_tabbar_category_selected()
        tabbarController.tabBar.items?[2].selectedImage = R.image.icon_tabbar_mytone_selected()
        tabbarController.tabBar.items?[3].selectedImage = R.image.icon_tabbar_setting_selected()
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

extension MainTabbarCoordinator: MainTabbarUpdate {
    func openRingtoneCatalog() {
        tabbarController.selectedIndex = 1
    }
        
}
