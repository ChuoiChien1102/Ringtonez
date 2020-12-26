//
//  HomeViewController.swift
//  ringtoney
//
//  Created by dong ka on 10/29/20.
//  Copyright (c) 2020 All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Permission
import SwiftRater


class HomeViewController: ViewController {
    
    //MARK:- Property
    let mediaLibrary: Permission = .mediaLibrary

    
    let premiumNavigationView = PremiumNavigationView()
    var homemakerView: HomeMakerView!
    var homeCatelogView: HomeCatelogView!
    
    let tapRingtoneMaker = PublishSubject<URL>.init()

    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //title = "ENTER YOUR TITLE HERE"
        //Code here
        Broadcaster.register(MediaPickerUpdate.self, observer: self)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if Defaults[\.launchCount] == 3 || Defaults[\.launchCount] == 6 || Defaults[\.launchCount] ==  9 {
                SwiftRater.check()
            }
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Code here
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Code here
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //Code here
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //Code here
    }
    
    //MARK:- Bind ViewModel
    override func bindViewModel() {
        super.bindViewModel()
        
        guard let viewModel = viewModel as? HomeViewModel else { return }
        
        
        homemakerView.rx.tap()
            .subscribe(onNext:{[weak self] _ in
                guard let self = self else { return }
                self.checkMediaLibraryPermission {
                    DispatchQueue.main.async {
                        DNMediaPicker.shared.rootViewController = self
                        DNMediaPicker.shared.presentMediaPicker()
                    }
                }
            })
            .disposed(by: bag)
        
        homeCatelogView.rx.tap()
            .subscribe(onNext:{[weak self] _ in
                guard let self = self else { return }
                Broadcaster.notify(MainTabbarUpdate.self) {
                    $0.openRingtoneCatalog()
                }
            })
            .disposed(by: bag)

        
        //Input
        let inputs = HomeViewModel.Input(
            ringmakerTrigger: tapRingtoneMaker.asObserver(),
            premiumTrigger: premiumNavigationView.premiumButton.rx.tap.asObservable()
        )
        
        //Outputs
        let output = viewModel.transform(input: inputs)
        
        
    }
    
    //MARK:- UI
    override func makeUI() {
        super.makeUI()
        //Code here
        addPremiumNavigationView()
        addTableView()
    }
    
    override func updateUI() {
        super.updateUI()
        
        stackView.spacing = 32
    }
    
    func addPremiumNavigationView() {
        stackView.addArrangedSubview(premiumNavigationView)
        premiumNavigationView.snp.makeConstraints { (make) in
            make.height.equalTo(50)
        }
        premiumNavigationView.setNeedsDisplay()
    }
    
    func addTableView() {
        
        let stack = StackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 32
        
        stackView.addArrangedSubview(stack)
        stackView.addArrangedSubview(Spacer())
        
        stack.snp.makeConstraints { (make) in
            make.height.equalTo(550)
        }
        homemakerView = HomeMakerView()
        stack.addArrangedSubview(homemakerView)
        homeCatelogView = HomeCatelogView()
        stack.addArrangedSubview(homeCatelogView)
        
    }
    
    func checkMediaLibraryPermission(completed: @escaping () -> Void) {
        
        mediaLibrary.request { (status) in
            switch status {
            case .authorized:
                print("authorized")
                completed()
            case .denied:
                print("denied")
            case .disabled:
                print("disabled")
            case .notDetermined:
                print("not determined")
            }
        }
    }

    
}

//MARK:- Extensition
extension HomeViewController {
    
        
}

extension HomeViewController : MediaPickerUpdate {
    
    func tunesMakerDidPickAudio(_ mediaObject: [String : Any]?) {
        guard let media = mediaObject else { return }
        guard let mediaURL = media["mediaUrl"] as? URL else { return }
        tapRingtoneMaker.onNext(mediaURL)
    }
    
}
