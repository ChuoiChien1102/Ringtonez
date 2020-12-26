//
//  PremiumAViewController.swift
//  ringtoney
//
//  Created by dong ka on 26/11/2020.
//  Copyright (c) 2020 All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SDCAlertView

class PremiumAViewController: PremiumBaseViewController {
    
    //MARK:- Property

    
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ENTER YOUR TITLE HERE"
        //Code here
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Code here
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Code here
        guard let v = premiumButtonContainerView as? FlashSaleView else { return }
        
        v.flashSaleImageView.animation = "swing"
        v.flashSaleImageView.repeatCount = 999
//        v.flashSaleImageView.curve = "linear"
        v.flashSaleImageView.duration = 1
        v.flashSaleImageView.animate()
    
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //Code here
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //Code here
    }
    
    
    //MARK:- Deinit
    deinit {
        log.debug("\(type(of: self)): Deinited")
    }
    
    //MARK:- Bind ViewModel
    override func bindViewModel() {
        super.bindViewModel()
        
        guard let viewModel = viewModel as? PremiumAViewModel else { return }
        
        guard let premiumContainer = self.premiumButtonContainerView as? FlashSaleView  else { return }

        //Input
        let inputs = PremiumAViewModel.Input(
            dismiss: header.closeButton.rx.tap.asObservable(),
            continueTrigger: continueButton.rx.tap().asObservable(),
            termOfUseTrigger: footer.privacyPolicyButton.rx.tap.asObservable(),
            privacyTrigger: footer.termOfUseButton.rx.tap.asObservable(),
            restoreTrigger: header.restoreButton.rx.tap.asObservable()
        )
        
        //Outputs
        let output = viewModel.transform(input: inputs)
        
        output.countDown
            .drive(onNext:{[weak self] value in
                guard let self = self else { return }
                guard let v = self.premiumButtonContainerView as? FlashSaleView else { return }
                v.limitedLabel.text = value
            })
            .disposed(by: bag)
        
        output.price
            .drive(onNext:{[weak self] priceStr in
                guard let self = self else { return }
                guard let v = self.premiumButtonContainerView as? FlashSaleView else { return }
                v.premiumButton.titleLabel.text = priceStr
            })
            .disposed(by: bag)
        
        output.purchaseStatus
            .drive(onNext:{[weak self] _status in
                guard let sts = _status else { return }
                switch sts {
                case .error(msg: let msg):
                    AlertController.alert(withTitle: "Message", message: msg, actionTitle: "OK")
                    break
                case .success: break
                }
            })
            .disposed(by: bag)
    }
    
    //MARK:- UI
    override func makeUI() {
        super.makeUI()
        //Code here
        
    }
    
    override func updateUI() {
        
    }
    
    
    override func addPremiumButtonContainer() {
        premiumButtonContainerView = FlashSaleView()
        super.addPremiumButtonContainer()
    }
    
    
}

//MARK:- Extensition
extension PremiumAViewController {
    
    
    
    
    
}
