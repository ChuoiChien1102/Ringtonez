//
//  PremiumBaseViewController.swift
//  ringtoney
//
//  Created by dong ka on 24/11/2020.
//  Copyright (c) 2020 All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class PremiumBaseViewController: ViewController {
    
    //MARK:- Property
    var header = PremiumHeaderView()
    var footer = PremiumFooterView()
    
    var backgroundImageView = ImageView().then {
        $0.image = R.image.background_premium()
    }
    
    var backgroundMask = ImageView().then {
        $0.image = R.image.background_premium_mask()
    }
    
    var logo = SpringImageView().then {
        $0.image = R.image.img_getpremium()
        $0.contentMode = .scaleAspectFit
        
    }
    
    var continueButton = Button().then {
        $0.setTitle("CONTINUE", for: .normal)
        $0.backgroundColor = UIColor.init(hexString: "9300FE")
        $0.titleLabel?.font = FontsManager.nasalization.font(size: 25)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
    }
    
    var premiumIntroView = PremiumIntroView()
//    var premiumButtonContainerView = PremiumSingleWView()
    //PremiumWYView
    var premiumButtonContainerView: View!
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ENTER YOUR TITLE HERE"
        //Code here
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Code here
        logo.animation = "pop"
        logo.repeatCount = 999
        logo.curve = "linear"
        logo.duration = 2
        logo.animate()

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
    
    
    //MARK:- Deinit
    deinit {
        log.debug("\(type(of: self)): Deinited")
    }
    
    //MARK:- Bind ViewModel
    override func bindViewModel() {
        super.bindViewModel()
        
        guard let viewModel = viewModel as? PremiumBaseViewModel else { return }
        
        //Input
        let inputs = PremiumBaseViewModel.Input()
        
        //Outputs
        let output = viewModel.transform(input: inputs)
        
    }
    
    //MARK:- UI
    override func makeUI() {
        
        addBackgroundImageView()
        addBackgroundMask()
        
        super.makeUI()
        contentView.clipsToBounds = false
        stackView.spacing = 16
        
        //Code here
        addHeaderView()
        addLogo()
        
        //stackView.addArrangedSubview(Spacer())
        
        addFeatureList()
        addPremiumButtonContainer()
        addContinueButton()
        
        addFooterView()
    }
    
    override func updateUI() {
        
    }
    
    func addBackgroundImageView() {
        view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            if DNDeviceManager.isIpad() {
                make.height.equalToSuperview().multipliedBy(0.86)
            } else {
                make.height.equalToSuperview().multipliedBy(0.5)
            }
        }
    }
    
    func addBackgroundMask() {
        view.addSubview(backgroundMask)
        backgroundMask.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(backgroundImageView.snp.bottom)
            make.height.equalTo(100)
        }
    }
        
    func addHeaderView() {
        stackView.addArrangedSubview(header)
        header.snp.makeConstraints { (make) in
            make.height.equalTo(50)
        }
    }
    
    func addLogo() {
        let container = View()
        container.clipsToBounds = false
        container.layer.masksToBounds = false
        container.backgroundColor = .clear
        stackView.addArrangedSubview(container)
//        container.snp.makeConstraints { (make) in
//            make.height.equalTo(220)
//        }
        
        container.addSubview(logo)
        logo.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().offset(-32)
            make.width.height.equalTo(400)
        }
        
    }
    
    func addFeatureList() {
        
        let container = View()
        stackView.addArrangedSubview(container)
        
        container.snp.makeConstraints { (make) in
            make.height.equalTo(150)
        }
        
        container.addSubview(premiumIntroView)
        premiumIntroView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview().offset(50)
            make.centerY.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(100)
        }
    }
    
    func addPremiumButtonContainer() {
        let container = View()
        stackView.addArrangedSubview(container)
        
        container.clipsToBounds = false
        container.layer.masksToBounds = false
        
        container.snp.makeConstraints { (make) in
//            make.height.equalTo(120)
            make.height.equalTo(140)
        }

        
        container.addSubview(premiumButtonContainerView)
        premiumButtonContainerView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(21)
            make.top.bottom.equalToSuperview()
        }
    }
    
    func addContinueButton() {
        
        let container = View()
        stackView.addArrangedSubview(container)
        
        
        container.snp.makeConstraints { (make) in
            make.height.equalTo(60)
        }
        
        container.addSubview(continueButton)
        continueButton.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(21)
            make.top.bottom.equalToSuperview()
        }
        
        continueButton.rx.tap
            .subscribe(onNext:{[weak self] _ in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    LoadingManager.show(in: self)
                }
            })
            .disposed(by: bag)
        
    }
    
    func addFooterView() {
        stackView.addArrangedSubview(footer)
        footer.snp.makeConstraints { (make) in
            make.height.equalTo(120)
        }
    }
    
    
    
}

//MARK:- Extensition
extension PremiumBaseViewController {
    
    
    
    
    
}
