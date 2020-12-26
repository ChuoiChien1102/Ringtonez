//
//  ViewController.swift
//  ringtoney
//
//  Created by dong ka on 10/29/20.
//

import Foundation
import SafariServices

class ViewController: UIViewController {
    
    //MARK:- Property
    var viewModel: ViewModel
    var bag = DisposeBag()
    
    let isLoading = BehaviorRelay(value: false)
    let error = PublishSubject<DNAPIError>()
        
    var stackView = UIStackView().then {
        $0.alignment = .fill
        $0.axis = .vertical
        $0.spacing = 0
    }
    
    var contentView: View = View().then {
        $0.backgroundColor = .clear
    }
    
    //MARK:- Init
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    deinit {
        log.debug("\(type(of: self)): Deinited")
    }
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //Code here
        self.navigationController?.isNavigationBarHidden = true
        makeUI()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Code here
        updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Code here
        updateUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //Code here
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //Code here
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:- Bind ViewModel
    func bindViewModel() {
        
    }
    
    //MARK:- UI
    func makeUI() {
        //Code here
        self.view.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        themeService.rx
            .bind({ $0.backgroundColor }, to: view.rx.backgroundColor)
            .disposed(by: bag)
    }
    
    func updateUI() {

    }
    
    @objc func openTermOfUse() {
        DispatchQueue.main.async {
            log.debug("Open term of use")
            if let url = URL(string: Configs.App.termOfUse) {
                let config = SFSafariViewController.Configuration()
                config.entersReaderIfAvailable = true
                let vc = SFSafariViewController(url: url, configuration: config)
                self.present(vc, animated: true, completion: nil)
            }
        }
    }

    
}
