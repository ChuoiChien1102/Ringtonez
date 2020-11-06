//
//  ViewControllerAssembly.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 5/9/19.
//  Copyright © 2019 ChuoiChien. All rights reserved.
//

import Swinject

final class Intro1ViewControllerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(Intro1ViewController.self) { _ in
            let vc = StoryboardScene.Main.intro1ViewController.instantiate()
            return vc
        }
    }
}
extension Intro1ViewController {
    static func newInstance() -> Intro1ViewController {
        let vc =  Container.shareResolver.resolve(Intro1ViewController.self)!
        return vc
    }
}

final class Intro2ViewControllerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(Intro2ViewController.self) { _ in
            let vc = StoryboardScene.Main.intro2ViewController.instantiate()
            return vc
        }
    }
}
extension Intro2ViewController {
    static func newInstance() -> Intro2ViewController {
        let vc =  Container.shareResolver.resolve(Intro2ViewController.self)!
        return vc
    }
}

final class IAPViewControllerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(IAPViewController.self) { _ in
            let vc = StoryboardScene.Main.iapViewController.instantiate()
            return vc
        }
    }
}
extension IAPViewController {
    static func newInstance() -> IAPViewController {
        let vc =  Container.shareResolver.resolve(IAPViewController.self)!
        return vc
    }
}
