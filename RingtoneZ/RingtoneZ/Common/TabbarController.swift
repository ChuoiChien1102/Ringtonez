//
//  TabbarController.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 5/9/19.
//  Copyright © 2019 ChuoiChien. All rights reserved.
//

import UIKit

fileprivate enum TabItem: Int {
    case home = 0
    case setting
}

class TabbarController: UITabBarController {
    
    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.tabBar.isTranslucent = false
//        self.delegate = self
//        let homeVC = UINavigationController(rootViewController: HomeViewController.newInstance(), navigationBarClass: NavigationBar.self)
//        let settingVC = UINavigationController(rootViewController: SettingViewController.newInstance(), navigationBarClass: NavigationBar.self)
//        
//        self.viewControllers = [homeVC, settingVC]
//        self.setTabBarItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func setViewControllers(_ viewControllers: [UIViewController]?, animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)
    }
}

extension TabbarController {
    func setTabBarItems() {
        let tabHome = (self.tabBar.items?[TabItem.home.rawValue])! as UITabBarItem
        tabHome.title = "Trang chủ"
        tabHome.image = UIImage(named: "ic_home")
        
        let tabSetting = (self.tabBar.items?[TabItem.setting.rawValue])! as UITabBarItem
        tabSetting.title = "Cài đặt"
        tabSetting.image = UIImage(named: "ic_setting")
    }
    
}

extension TabbarController: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        switch tabBar.selectedItem {
        case tabBar.items?[TabItem.home.rawValue]:
            break
            
        case tabBar.items?[TabItem.setting.rawValue]:
            break
            
        default:
            break
        }
    }
    
}
