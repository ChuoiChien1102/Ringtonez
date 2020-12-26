//
//  CategoryViewController.swift
//  ringtoney
//
//  Created by dong ka on 11/2/20.
//  Copyright (c) 2020 All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class CategoryViewController: ViewController {
    
    //MARK:- Property
    var searchContainerView = SearchContainerView()
    var tableView: TableView!
    var dataSource: RxTableViewSectionedReloadDataSource<CatalogSectionModel>!
    
    let trendingSelected = PublishSubject<Category?>.init()
    let searchRingtone = PublishSubject<String?>.init()
    
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
        
        guard let viewModel = viewModel as? CategoryViewModel else { return }
        
        let refresh = Observable.of(rx.viewDidAppear.mapToVoid()).merge()
        
        //Input
        let inputs = CategoryViewModel.Input(trigger: refresh,
                                             selection:
                                                tableView.rx.modelSelected(CatalogSectionItem.self).asDriver(),
                                             trendingSelected: trendingSelected.asObservable(),
                                             searchRingtone: searchRingtone.asObservable())
        
        //Outputs
        let output = viewModel.transform(input: inputs)
        
        dataSource = self.getDataSource()
        
        output.items
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
    }
    
    //MARK:- UI
    override func makeUI() {
        super.makeUI()
        //Code here
        addSearchContainerView()
        addTableView()
    }
    
    override func updateUI() {
        
    }
    
    func addSearchContainerView() {
        stackView.addArrangedSubview(searchContainerView)
        searchContainerView.snp.makeConstraints { (make) in
            make.height.equalTo(60)
        }
        searchContainerView.searchBar.delegate = self
//        searchContainerView.searchBar.searchTextField.doneAccessory = true
    }
    
    func addTableView() {
        tableView = TableView.init(frame: .zero, style: .grouped)
        stackView.addArrangedSubview(tableView)
//        tableView.rowHeight = 90
//        tableView.estimatedRowHeight = 90
        tableView.separatorStyle = .none
        tableView.register(CatalogCell.self, forCellReuseIdentifier: CatalogCell.identifier)
        tableView.register(CatalogTopCategoryCell.self, forCellReuseIdentifier: CatalogTopCategoryCell.identifier)
        tableView
          .rx.setDelegate(self)
          .disposed(by: bag)
    }
    
}

//MARK:- Extensition
extension CategoryViewController: UITableViewDelegate {
    
    func getDataSource() -> RxTableViewSectionedReloadDataSource<CatalogSectionModel> {
        return RxTableViewSectionedReloadDataSource<CatalogSectionModel>(
            configureCell: { (_dataSources, table, indexPath, item)  -> TableViewCell in
                
                switch _dataSources[indexPath] {
                case .trend(let trending):
                    let cell: CatalogTopCategoryCell = table.dequeueReusableCell(withIdentifier: CatalogTopCategoryCell.identifier, for: indexPath) as! CatalogTopCategoryCell
                    cell.bind(to: trending)
                    
                    cell.itemSelected = {[weak self] item in
                        self?.trendingSelected.onNext(item)
                    }

                    return cell
                    
                case .category(let cate):
                    let cell: CatalogCell = table.dequeueReusableCell(withIdentifier: CatalogCell.identifier, for: indexPath) as! CatalogCell
                    cell.bind(to: cate)
                    return cell
                }
            },
            titleForHeaderInSection: { dataSource, index in
                let section = dataSource[index]
                return section.title
            }
        )
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = CatalogTableViewHeader()
        headerView.title.text = dataSource[section].title
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 70 : 64
    }

    
}

extension CategoryViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchRingtone.onNext(searchBar.text)
        log.debug("Search string: \(searchBar.text)")
        searchBar.endEditing(true)
    }
    
}
