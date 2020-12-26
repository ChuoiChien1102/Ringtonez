//
//  MainTabbarViewController.swift
//  ringtoney
//
//  Created by dong ka on 11/2/20.
//  Copyright (c) 2020 All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class MainTabbarViewController: ViewController {
    
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
        
        guard let viewModel = viewModel as? MainTabbarViewModel else { return }
        
        //Input
        let inputs = MainTabbarViewModel.Input()
        
        //Outputs
        let output = viewModel.transform(input: inputs)
        
    }
    
    //MARK:- UI
    override func makeUI() {
        super.makeUI()
        //Code here
        
    }
    
    override func updateUI() {
        
    }

    
    
    
    
}

//MARK:- Extensition
extension MainTabbarViewController {
    
    
    
    
    
}
