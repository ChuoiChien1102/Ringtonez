//
//  MytoneViewController.swift
//  ringtoney
//
//  Created by dong ka on 11/2/20.
//  Copyright (c) 2020 All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SDCAlertView

class MytoneViewController: ViewController {
    
    //MARK:- Property
    var tableView: TableView!
    var mytoneOptionView = MytoneOptionView()
    var baseNavigationview = BaseNavigationview()
    var editNameView = EditNameView()
    
    let editTrigger = PublishSubject<Ringtone>.init()
    let renameTrigger = PublishSubject<Ringtone>.init()
    let deleteTrigger = PublishSubject<Ringtone>.init()
    let installTrigger = PublishSubject<Ringtone>.init()
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //title = "ENTER YOUR TITLE HERE"
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
        
        let playAtIndex = PublishSubject<Int>.init()
        let tapMore = PublishSubject<Int>.init()
        
        guard let viewModel = viewModel as? MytoneViewModel else { return }
        
        //Input
        let inputs = MytoneViewModel.Input(
            recordSelected: mytoneOptionView.recordButton.rx.tap.asObservable(),
            ringtoneTabTrigger: mytoneOptionView.ringtoneButton.rx.tap.asObservable(),
            trackTabTrigger: mytoneOptionView.trackButton.rx.tap.asObservable(),
            playpauseTrigger: playAtIndex.asObservable(),
            moreTrigger: tapMore.asObserver(),
            editTrigger: self.editTrigger.asObserver(),
            renameTrigger: self.renameTrigger.asObserver(),
            deleteTringer: self.deleteTrigger.asObserver(),
            installTrigger: self.installTrigger.asObserver(),
            premiumTrigger: baseNavigationview.premiumButton.rx.tap.asObservable()

        )
        
        //Outputs
        let output = viewModel.transform(input: inputs)
        
        output.items
            .drive(tableView.rx.items(cellIdentifier: MytoneCell.identifier, cellType: MytoneCell.self)) {
                (indexPath, element, cell) in
                cell.bind(to: element)
                
                cell.playButton.rx.tap
                    .map { _ in return indexPath }
                    .bind(to: playAtIndex)
                    .disposed(by: cell.cellDisposeBag)
                
                cell.moreButton.rx.tap
                    .map{_ in return indexPath}
                    .bind(to: tapMore)
                    .disposed(by: cell.cellDisposeBag)
                
            }
            .disposed(by: bag)
        
        
        output.isSelectedTrackTab
            .do(onNext:{[weak self] value in
                self?.mytoneOptionView.trackButton.updateBackgroundColor(_isSelected: value)
            })
            .drive(mytoneOptionView.trackButton.rx.isSelected)
            .disposed(by: bag)
        
        output.isSelectedTrackTab
            .map{!$0}
            .do(onNext:{[weak self] value in
                self?.mytoneOptionView.ringtoneButton.updateBackgroundColor(_isSelected: value)
            })
            .drive(mytoneOptionView.ringtoneButton.rx.isSelected)
            .disposed(by: bag)
        
        output.showMoreOption
            .subscribe(onNext:{[weak self] ringtone in
                guard let self = self else { return }
                self.showMoreActionSheet(ringtone)
            })
            .disposed(by: bag)
        
    }
    
    //MARK:- UI
    override func makeUI() {
        super.makeUI()
        //Code here
        addNavigationView()
        addMytoneHeaderView()
        addTableView()
        
        addEditNameView()
    }
    
    override func updateUI() {
        super.updateUI()
        
    }
    
    func addNavigationView() {
        stackView.addArrangedSubview(baseNavigationview)
        baseNavigationview.snp.makeConstraints { (make) in
            make.height.equalTo(50)
        }
        baseNavigationview.titleLabel.text = "My tone"
//        baseNavigationview.isHiddenPremiumButton = false
    }
    
    func addMytoneHeaderView() {
        stackView.addArrangedSubview(mytoneOptionView)
        mytoneOptionView.snp.makeConstraints { (make) in
            make.height.equalTo(70)
        }
    }
    
    func addTableView() {
        tableView = TableView.init(frame: .zero, style: .plain)
        stackView.addArrangedSubview(tableView)
        tableView.rowHeight = 64
        tableView.separatorStyle = .none
        tableView.register(MytoneCell.self, forCellReuseIdentifier: MytoneCell.identifier)
    }
}

//MARK:- Extensition
extension MytoneViewController {
    
    func showMoreActionSheet(_ ringtone: Ringtone) {
        
        let alert = AlertController(title: "Choose your option to change", message: "\(ringtone.name)", preferredStyle: .actionSheet)
        
        alert.addAction(AlertAction(title: "Install ringtone", style: .normal, handler: {[weak self] action in
            guard let self = self else { return }
            LoadingManager.success(in: self)
            self.installTrigger.onNext(ringtone)
        }))

        alert.addAction(AlertAction(title: "Edit", style: .normal, handler: {[weak self] action in
            guard let self = self else { return }
            self.editTrigger.onNext(ringtone)
        }))
        alert.addAction(AlertAction(title: "Rename", style: .normal, handler: {[weak self] action in
            guard let self = self else { return }
            self.editNameView.show(Target: ringtone)
        }))
        alert.addAction(AlertAction(title: "Delete", style: .destructive, handler: {[weak self] action in
            guard let self = self else { return }
            self.showAlertDelegate(RingtoneToDelete: ringtone)
        }))

        alert.addAction(AlertAction(title: "Cancel", style: .preferred))

        alert.present()
        
        
    }
    
    
    func addEditNameView() {
        self.view.addSubview(editNameView)
        editNameView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        editNameView.hide(animate: false)
        
        editNameView.cancelButton.rx.tap
            .subscribe(onNext:{[weak self] _ in
                guard let self = self else { return }
                self.editNameView.hide(animate: true)
            })
            .disposed(by: bag)
        
        editNameView.submitButton.rx.tap
            .subscribe(onNext:{[weak self] _ in
                guard let self = self else { return }
                
                let newRingtone = self.editNameView.ringtone
                newRingtone?.name = self.editNameView.textField.text ?? "No name"
                self.renameTrigger.onNext(newRingtone!)
                self.editNameView.textField.endEditing(true)
                self.editNameView.hide(animate: true)
                
            })
            .disposed(by: bag)
        
        
    }
    
    func showAlertDelegate(RingtoneToDelete ringtone: Ringtone) {
        let alert = AlertController(title: "Are you sure delete this ringtone?", message: "The ringtone will lost", preferredStyle: .alert)
        alert.addAction(AlertAction(title: "Cancel", style: .normal))
        alert.addAction(AlertAction(title: "Delete", style: .destructive, handler: {[weak self] action in
            guard let self = self else { return }
            self.deleteTrigger.onNext(ringtone)
        }))
        alert.present()
    }
        
}
