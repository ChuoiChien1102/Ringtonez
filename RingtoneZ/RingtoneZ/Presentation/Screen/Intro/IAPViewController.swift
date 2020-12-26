//
//  IAPViewController.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 11/5/20.
//

import UIKit
import SafariServices
import SDCAlertView

class IAPViewController: BaseViewController {
    
    @IBOutlet weak var contentViewTopContraint: NSLayoutConstraint!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var viewWeekly: UIView!
    @IBOutlet weak var imgWeekly: UIImageView!
    @IBOutlet weak var lbWeekly1: UILabel!
    @IBOutlet weak var lbWeekly2: UILabel!
    
    @IBOutlet weak var viewLifetime: UIView!
    @IBOutlet weak var imgLifetime: UIImageView!
    @IBOutlet weak var lbLifetime: UILabel!
    
    var isWeekly = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnNext.applyGradient(colors: [UIColor.init(hex: "#9138FD").cgColor, UIColor.init(hex: "#E500BB").cgColor])
        if IS_IPHONE_5_5S_SE {
            contentViewTopContraint.constant = 40;
        } else if IS_IPHONE_6_6S_7_8 {
            contentViewTopContraint.constant = 120;
        } else if IS_IPHONE_6PLUS_7PLUS_8PLUS {
            contentViewTopContraint.constant = 150;
        } else if IS_IPHONE_X_XS {
            contentViewTopContraint.constant = 180;
        } else if IS_IPHONE_XR_XSMAX {
            contentViewTopContraint.constant = 200;
        } else {
            contentViewTopContraint.constant = 200;
        }
        
        viewWeekly.isUserInteractionEnabled = true
        let tapGestureTrial = UITapGestureRecognizer(target: self, action: #selector(clickWeekly(_:)))
        viewWeekly.addGestureRecognizer(tapGestureTrial)
        
        viewLifetime.isUserInteractionEnabled = true
        let tapGesturePay = UITapGestureRecognizer(target: self, action: #selector(clickLifetime(_:)))
        viewLifetime.addGestureRecognizer(tapGesturePay)
        
        getProductInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @objc func clickWeekly(_ recognizer: UITapGestureRecognizer) {
        isWeekly = true
        updateUI()
    }
    
    @objc func clickLifetime(_ recognizer: UITapGestureRecognizer) {
        isWeekly = false
        updateUI()
    }
    
    @IBAction func clickNext(_ sender: Any) {
        var productToPurchase = Keys.weekly.appId
        if isWeekly == false {
            productToPurchase = Keys.lifetime.appId
        }
        LoadingManager.show(in: self)
        PurchaserManager.purchaseAProduct(productID: productToPurchase) {
            LoadingManager.hide()
            self.dismiss(animated: true, completion: nil)
        } failureHandler: { (str) in
            LoadingManager.hide()
            let alert = AlertController(title: "Purchase failed", message: str, preferredStyle: .alert)
            alert.addAction(AlertAction(title: "OK", style: .normal))
//            alert.modalPresentationStyle = .fullScreen
            alert.present()
        }
    }
    
    @IBAction func clickClose(_ sender: Any) {
        if IS_FIRST_IAP.isFirstIAP == true {
            IS_FIRST_IAP.isFirstIAP = false
            let navi = UINavigationController(rootViewController: HomeViewController.newInstance(), navigationBarClass: NavigationBar.self)
            appDelegate?.changeRootViewController(navi)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func clickRestore(_ sender: Any) {
        LoadingManager.show(in: self)
        PurchaserManager.restorePurchase {
            LoadingManager.hide()
            self.dismiss(animated: true, completion: nil)
        } failurehandler: { (str) in
            LoadingManager.hide()
            let alert = AlertController(title: "Restore failed", message: str, preferredStyle: .alert)
            alert.addAction(AlertAction(title: "OK", style: .normal))
//            alert.modalPresentationStyle = .fullScreen
            alert.present()
        }
    }
    
    @available(iOS 11.0, *)
    @IBAction func clickTerms(_ sender: Any) {
        if let url = URL(string: App.termOfUse) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            let vc = SFSafariViewController(url: url, configuration: config)
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @available(iOS 11.0, *)
    @IBAction func clickPolicy(_ sender: Any) {
        if let url = URL(string: App.termOfUse) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            let vc = SFSafariViewController(url: url, configuration: config)
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
}

extension IAPViewController {
    
    func updateUI() ->  Void {
        if isWeekly {
            viewWeekly.backgroundColor = UIColor.white
            imgWeekly.image = UIImage(named: "check")
            lbWeekly1.textColor = UIColor.black
            lbWeekly2.textColor = UIColor.black
            
            viewLifetime.backgroundColor = UIColor.clear
            imgLifetime.image = UIImage(named: "uncheck")
            lbLifetime.textColor = UIColor.white
        } else {
            viewWeekly.backgroundColor = UIColor.clear
            imgWeekly.image = UIImage(named: "uncheck")
            lbWeekly1.textColor = UIColor.white
            lbWeekly2.textColor = UIColor.white
            
            viewLifetime.backgroundColor = UIColor.white
            imgLifetime.image = UIImage(named: "check")
            lbLifetime.textColor = UIColor.black
        }
    }
    
    func getProductInfo() -> Void {
        LoadingManager.show(in: self)
        PurchaserManager.getInfo(ProductIds: [Keys.weekly.appId, Keys.lifetime.appId]) { (skProducts) in
            LoadingManager.hide()
            for i in skProducts {
                guard let price = i.localizedPrice else { return }
                print(price)
                if i.productIdentifier == Keys.weekly.appId {
                    var str = "then "
                    str = str.appending(price)
                    str = str.appending(" peer week")
                    self.lbWeekly2.text = str
                }
                if i.productIdentifier == Keys.lifetime.appId {
                    var str = "Lifetime "
                    str = str.appending(price)
                    self.lbLifetime.text = str
                }
            }
        }
    }
}
