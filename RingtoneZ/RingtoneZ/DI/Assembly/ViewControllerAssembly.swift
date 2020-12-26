//
//  ViewControllerAssembly.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 5/9/19.
//  Copyright © 2019 ChuoiChien. All rights reserved.
//

import Swinject

final class SplashViewControllerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(SplashViewController.self) { _ in
            let vc = StoryboardScene.Main.splashViewController.instantiate()
            return vc
        }
    }
}
extension SplashViewController {
    static func newInstance() -> SplashViewController {
        let vc =  Container.shareResolver.resolve(SplashViewController.self)!
        return vc
    }
}

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

final class HomeViewControllerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(HomeViewController.self) { _ in
            let vc = StoryboardScene.Main.homeViewController.instantiate()
            return vc
        }
    }
}
extension HomeViewController {
    static func newInstance() -> HomeViewController {
        let vc =  Container.shareResolver.resolve(HomeViewController.self)!
        return vc
    }
}

final class SettingViewControllerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(SettingViewController.self) { _ in
            let vc = StoryboardScene.Main.settingViewController.instantiate()
            return vc
        }
    }
}
extension SettingViewController {
    static func newInstance() -> SettingViewController {
        let vc =  Container.shareResolver.resolve(SettingViewController.self)!
        return vc
    }
}

final class CategoriesViewControllerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(CategoriesViewController.self) { _ in
            let vc = StoryboardScene.Main.categoriesViewController.instantiate()
            return vc
        }
    }
}
extension CategoriesViewController {
    static func newInstance() -> CategoriesViewController {
        let vc =  Container.shareResolver.resolve(CategoriesViewController.self)!
        return vc
    }
}

final class RecordViewControllerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(RecordViewController.self) { _ in
            let vc = StoryboardScene.Main.recordViewController.instantiate()
            return vc
        }
    }
}
extension RecordViewController {
    static func newInstance() -> RecordViewController {
        let vc =  Container.shareResolver.resolve(RecordViewController.self)!
        return vc
    }
}

final class MakerViewControllerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(MakerViewController.self) { _ in
            let vc = StoryboardScene.Main.makerViewController.instantiate()
            return vc
        }
    }
}
extension MakerViewController {
    static func newInstance() -> MakerViewController {
        let vc =  Container.shareResolver.resolve(MakerViewController.self)!
        return vc
    }
}

final class MyToneViewControllerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(MyToneViewController.self) { _ in
            let vc = StoryboardScene.Main.myToneViewController.instantiate()
            return vc
        }
    }
}
extension MyToneViewController {
    static func newInstance() -> MyToneViewController {
        let vc =  Container.shareResolver.resolve(MyToneViewController.self)!
        return vc
    }
}

final class DetailCategoryViewControllerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(DetailCategoryViewController.self) { _ in
            let vc = StoryboardScene.Main.detailCategoryViewController.instantiate()
            return vc
        }
    }
}
extension DetailCategoryViewController {
    static func newInstance() -> DetailCategoryViewController {
        let vc =  Container.shareResolver.resolve(DetailCategoryViewController.self)!
        return vc
    }
}

final class TutorialViewControllerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(TutorialViewController.self) { _ in
            let vc = StoryboardScene.Main.tutorialViewController.instantiate()
            return vc
        }
    }
}
extension TutorialViewController {
    static func newInstance() -> TutorialViewController {
        let vc =  Container.shareResolver.resolve(TutorialViewController.self)!
        return vc
    }
}
