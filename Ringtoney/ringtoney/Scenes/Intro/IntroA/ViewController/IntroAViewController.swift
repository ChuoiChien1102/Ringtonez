//
//  IntroAViewController.swift
//  ringtoney
//
//  Created by dong ka on 28/11/2020.
//  Copyright (c) 2020 All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class IntroAViewController: ViewController {
    
    //MARK:- Property
    var backgroundImageView = ImageView().then {
        $0.image = R.image.background_introA()
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    var backgroundMask = ImageView().then {
        $0.image = R.image.background_premium_mask()
    }
    
    var titleLabel = Label().then{
        $0.text = "Welcome to Ringtones"
        $0.font = FontsManager.nasalization.font(size: 25)
        $0.numberOfLines = 1
        $0.textColor = UIColor.init(hexString: "FFFFFF")
        $0.textAlignment = .left
    }
    var descLabel = Label().then {
        $0.text = "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to"
        $0.font = FontsManager.nasalization.font(size: 17)
        $0.numberOfLines = 0
        $0.textColor = UIColor.init(hexString: "FFFFFF")
        $0.textAlignment = .justified
    }
    
    var continueButton = Button().then {
        $0.setTitle("CONTINUE", for: .normal)
        $0.backgroundColor = UIColor.init(hexString: "9300FE")
        $0.titleLabel?.font = FontsManager.nasalization.font(size: 25)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
    }
    
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
        
        guard let viewModel = viewModel as? IntroAViewModel else { return }
        
        //Input
        let inputs = IntroAViewModel.Input(
            continueTrigger: continueButton.rx.tap.asObservable()
        )
        
        //Outputs
        let output = viewModel.transform(input: inputs)
        
    }
    
    //MARK:- UI
    override func makeUI() {
        
        
        //Code here
        addBackgroundImageView()
        addBackgroundMask()

        
        super.makeUI()
        
        stackView.spacing = 16
        stackView.distribution = .fill
    
        
        addTitleLabel()
        addDescLabel()
        addContinueButton()
        
    }
    
    override func updateUI() {
        
    }
    
    func addBackgroundImageView() {
        view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-200)
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
    
    func addTitleLabel() {
                
        stackView.addArrangedSubview(Spacer())
        
        //log.debug("Call")
        let container = View()
        container.backgroundColor = .clear
        stackView.addArrangedSubview(container)
        
        container.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.bottom.equalToSuperview()
        }

    }
    
    func addDescLabel() {
        
        let container = View()
        container.backgroundColor = .clear
        container.layer.masksToBounds = false
        container.clipsToBounds = false
        stackView.addArrangedSubview(container)
            
        container.addSubview(descLabel)
        descLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.bottom.equalToSuperview()
        }
        
    }
    
    func addContinueButton() {
        
        let container = View()
        
        stackView.addArrangedSubview(container)
        container.snp.makeConstraints { (make) in
            make.height.equalTo(120)
        }
        
        container.addSubview(continueButton)
        continueButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(50)
        }
        
        
    }
    
    
}

//MARK:- Extensition
extension IntroAViewController {
    
    
    
    
    
}
