//
//  SearchDetailViewController.swift
//  ringtoney
//
//  Created by dong ka on 11/10/20.
//  Copyright (c) 2020 All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import UIScrollView_InfiniteScroll

class SearchDetailViewController: ViewController {
    
    //MARK:- Property
    var backNavigationView = BackNavigationView()
    var tableView: TableView!
    
    let loadMore = PublishSubject<Void>.init()

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
        
        let playAtIndex = PublishSubject<Int>.init()
        let tapMore = PublishSubject<Int>.init()
        
        guard let viewModel = viewModel as? SearchDetailViewModel else { return }
        
        //Input
        let inputs = SearchDetailViewModel.Input(
            dismiss: backNavigationView.backButton.rx.tap.asObservable(),
            playpauseTrigger: playAtIndex.asObservable(),
            moreTrigger: tapMore.asObserver(),
            loadMore: loadMore.asObserver()
        )
        
        //Outputs
        let output = viewModel.transform(input: inputs)
        
        output.title
            .drive(backNavigationView.titleLabel.rx.text)
            .disposed(by: bag)
        
        output.items
            .drive(tableView.rx.items(cellIdentifier: CategoryDetailCell.identifier, cellType: CategoryDetailCell.self)) {
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
        
        output.finishInfinityScroll
            .subscribe(onNext:{[weak self] _ in
                guard let self = self else { return }
                self.finishInfinityScroll()
            })
            .disposed(by: bag)

    }
    
    //MARK:- UI
    override func makeUI() {
        super.makeUI()
        //Code here
        addNavigationView()
        addTableView()
    }
    
    override func updateUI() {
        
    }
    
    func addNavigationView() {
        stackView.addArrangedSubview(backNavigationView)
        backNavigationView.snp.makeConstraints { (make) in
            make.height.equalTo(50)
        }
    }
    
    func addTableView() {
        tableView = TableView.init(frame: .zero, style: .plain)
        stackView.addArrangedSubview(tableView)
        tableView.rowHeight = 64
        tableView.separatorStyle = .none
        tableView.register(CategoryDetailCell.self, forCellReuseIdentifier: CategoryDetailCell.identifier)
        
        tableView.addInfiniteScroll { (tbv) in
            self.loadMore.onNext(Void())
        }

    }
    
    func finishInfinityScroll() {
        tableView.finishInfiniteScroll()
    }
    
 
}

//MARK:- Extensition
extension SearchDetailViewController {
    
    
    
    
    
}
