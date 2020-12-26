//
//  BootViewController.swift
//  ringtoney
//
//  Created by dong ka on 28/11/2020.
//  Copyright (c) 2020 All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class BootViewController: ViewController {
    
    //MARK:- Property
    let backgroundImageView = ImageView().then {
        $0.image = R.image.splash()
        $0.contentMode = .scaleAspectFill
        
    }
    
    let indicator = UIActivityIndicatorView().then {
        $0.startAnimating()
        $0.tintColor = UIColor.init(hex: "ffffff")
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
        
        guard let viewModel = viewModel as? BootViewModel else { return }
        
        //Input
        let inputs = BootViewModel.Input()
        
        //Outputs
        let output = viewModel.transform(input: inputs)
        
    }
    
    //MARK:- UI
    override func makeUI() {
        addSplashImageView()
        super.makeUI()
        //Code here
        addIndicator()
    }
    
    override func updateUI() {
        
    }
    
    func addSplashImageView() {
        self.view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    
    func addIndicator() {
        stackView.addArrangedSubview(Spacer())
        stackView.addArrangedSubview(indicator)
        indicator.snp.makeConstraints { (make) in
            make.height.equalTo(50)
        }
        let space = Spacer()
        stackView.addArrangedSubview(space)
        space.snp.makeConstraints { (make) in
            make.height.equalTo(50)
        }
    }
    
}

//MARK:- Extensition
extension BootViewController {
    
    
    
    
    
}
