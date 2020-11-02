//
//  ViewControllerAssembly.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 5/9/19.
//  Copyright © 2019 ChuoiChien. All rights reserved.
//

import Swinject

final class LoginViewControllerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(LoginViewController.self) { _ in
            let vc = StoryboardScene.Main.loginViewController.instantiate()
            return vc
        }
    }
}
extension LoginViewController {
    static func newInstance() -> LoginViewController {
        let vc =  Container.shareResolver.resolve(LoginViewController.self)!
        return vc
    }
}
