//
//  LoginViewController.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 5/9/19.
//  Copyright © 2019 ChuoiChien. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var titleContraintTop: NSLayoutConstraint!
    @IBOutlet weak var titleContraintBottom: NSLayoutConstraint!
    
    @IBOutlet weak var titleLogin: UILabel!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var iconSavePass: UIImageView!
    @IBOutlet weak var viewSavePass: UIView!
    @IBOutlet weak var lbForgotPass: UILabel!
    
    var isSavePass = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.navigationController?.isNavigationBarHidden = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickSavePass(_:)))
        viewSavePass.addGestureRecognizer(tapGesture)
        let tapGestureForgotPass = UITapGestureRecognizer(target: self, action: #selector(clickForgotPass(_:)))
        lbForgotPass.addGestureRecognizer(tapGestureForgotPass)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    @objc func clickSavePass(_ recognizer: UITapGestureRecognizer) {
        isSavePass = !isSavePass
        if isSavePass == true {
            iconSavePass.image = UIImage(named: "ic_checkbox_white")
        } else {
            iconSavePass.image = UIImage(named: "ic_un_checkbox_white")
        }
    }
    
    @objc func clickForgotPass(_ recognizer: UITapGestureRecognizer) {
        // go to forgot pass screen
    }
    
    @IBAction func invokedLogin(_ sender: Any) {
        var dic = [String: Any]()
        dic["username"] = txtUserName.text
        dic["password"] = txtPass.text
        
        showHUD()
        ApiSevice.login(dic) { (response, err) in
            self.hideHUD()
            if err == nil {
                UIUtils.storeObjectToUserDefault(response?.session as AnyObject, key: KEY_SESSION)
                UIUtils.storeObjectToUserDefault(self.isSavePass as AnyObject, key: KEY_IS_SAVEPASS)
                UIUtils.storeObjectToUserDefault(self.txtUserName.text as AnyObject, key: KEY_ACCOUNT)
                UIUtils.storeObjectToUserDefault(self.txtPass.text as AnyObject, key: KEY_PASSWORD)
                
                // call api login success
                let user = UserModel()
                user.id = 1
                user.session = response?.session
                user.type_user = 1
                UIUtils.storeObjectToUserDefault(user as AnyObject, key: KEY_USER_INFO)
                
//                let navi = UINavigationController(rootViewController: DashboardViewController.newInstance(), navigationBarClass: NavigationBar.self)
//                let leftMennu = MenuViewController.newInstance()
//                let sideMenuController = LGSideMenuController(rootViewController: navi,
//                                                              leftViewController: leftMennu,
//                                                              rightViewController: nil)
//                sideMenuController.leftViewWidth = WIDTH_DEVICE - 50
//                sideMenuController.leftViewPresentationStyle = .slideBelow
//                self.appDelegate?.changeRootViewController(sideMenuController)

            } else {
                
            }
        }
    }
}

extension LoginViewController {
    func setupUI() -> Void {
        let isSave = UIUtils.getObjectFromUserDefault(KEY_IS_SAVEPASS) as? Bool
        if isSave != nil {
            isSavePass = isSave!
        }
        if isSavePass == true {
            iconSavePass.image = UIImage(named: "ic_checkbox_white")
            txtUserName.text = UIUtils.getObjectFromUserDefault(KEY_ACCOUNT) as? String
            txtPass.text = UIUtils.getObjectFromUserDefault(KEY_PASSWORD) as? String
        }
        if IS_IPHONE_5_5S_SE {
            titleContraintTop.constant = 60
            titleContraintBottom.constant = 30
            titleLogin.setAttributeString(titleLogin.text!, font: FONT_DESCRIPTION_NAME.FONT_SYMBOL, size: 15, color: .white)
        }
        txtUserName.setPaddingLeft(25)
        txtPass.setPaddingLeft(25)
    }
}
