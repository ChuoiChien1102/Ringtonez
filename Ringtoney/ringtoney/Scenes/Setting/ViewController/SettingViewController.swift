//
//  SettingViewController.swift
//  ringtoney
//
//  Created by dong ka on 11/2/20.
//  Copyright (c) 2020 All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SwiftyUserDefaults
import SafariServices
import SwiftRater
import MessageUI

class SettingViewController: ViewController, MFMailComposeViewControllerDelegate {
    
    //MARK:- Property
    var tableView: TableView!
    var baseNavigationview = BaseNavigationview()
    var dataSource: RxTableViewSectionedReloadDataSource<SettingSectionModel>!
    
    var settingBannerView = SettingBanner()
    
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
        
        guard let viewModel = viewModel as? SettingViewModel else { return }
        
        let refresh = Observable.of(rx.viewDidAppear.mapToVoid()).merge()
        
        //Input
        let inputs = SettingViewModel.Input(
            trigger: refresh,
            selection: tableView.rx.itemSelected.asObservable(),
            premiumTrigger: self.settingBannerView.rx.tap().asObservable()
        )
        
        //Outputs
        let output = viewModel.transform(input: inputs)
        
        dataSource = SettingViewController.dataSource()
        
        output.items
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
        output.openRating
            .subscribe(onNext:{[weak self] _ in
                guard let self = self else { return }
                self.rateApp()
            })
            .disposed(by: bag)
        
        output.sendEmail
            .subscribe(onNext:{[weak self] _ in
                guard let self = self else { return }
                self.sendEmail()
            })
            .disposed(by: bag)
        
        output.shareApp
            .subscribe(onNext:{[weak self] _ in
                guard let self = self else { return }
                self.shareApp()
            })
            .disposed(by: bag)
    }
    
    //MARK:- UI
    override func makeUI() {
        super.makeUI()
        //Code here
        addNavigationView()
        addSettingBannerView()
        addTableView()
    }
    
    override func updateUI() {
        super.updateUI()
        
    }
    
    func addNavigationView() {
        stackView.addArrangedSubview(baseNavigationview)
        baseNavigationview.snp.makeConstraints { (make) in
            make.height.equalTo(50)
        }
        baseNavigationview.titleLabel.text = "Settings"
    }
    
    func addTableView() {
        tableView = TableView.init(frame: .zero, style: .grouped)
        stackView.addArrangedSubview(tableView)
        tableView.rowHeight = 64
        tableView.separatorStyle = .none
        tableView.register(SettingCell.self, forCellReuseIdentifier: SettingCell.identifier)
        tableView
            .rx.setDelegate(self)
            .disposed(by: bag)
    }
    
    func addSettingBannerView() {
        stackView.addArrangedSubview(settingBannerView)
        settingBannerView.snp.makeConstraints { (make) in
            make.height.equalTo(64)
        }
        
        IAP_OBSERVABLE
            .subscribe(onNext:{[weak self] isPurchase in
                guard let self = self else { return }
                    if isPurchase {
                        self.settingBannerView.isHidden = true
                        self.settingBannerView.isUserInteractionEnabled = false
                    } else {
                        self.settingBannerView.isHidden = false
                        self.settingBannerView.isUserInteractionEnabled = true
                    }
            })
            .disposed(by: bag)
        
    }
    
    
    //MARK:- Function
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([Configs.App.emailSupport])
            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)

            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    func shareApp(){
        if let urlStr = NSURL(string: Configs.App.ituneURL) {
            let objectsToShare = [urlStr]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                if let popup = activityVC.popoverPresentationController {
                    popup.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
                    popup.sourceView = self.view
                    popup.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
                }
            }
            
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    func rateApp() {
        SwiftRater.rateApp(host: self)
    }
    
    
}

//MARK:- Extensition
extension SettingViewController: UITableViewDelegate {
    
    static func dataSource() -> RxTableViewSectionedReloadDataSource<SettingSectionModel> {
        return RxTableViewSectionedReloadDataSource<SettingSectionModel>(
            configureCell: { (_dataSources, table, indexPath, item)  -> TableViewCell in
                
                switch _dataSources[indexPath] {
                case .base(let setting):
                    let cell: SettingCell = table.dequeueReusableCell(withIdentifier: SettingCell.identifier, for: indexPath) as! SettingCell
                    cell.bind(to: setting)
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
        let headerView = SettingsTableViewHeader()
        headerView.title.text = dataSource[section].title
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 64 : 64
    }
    
    
}

