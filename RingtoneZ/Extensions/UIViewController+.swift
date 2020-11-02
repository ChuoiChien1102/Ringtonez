//
//  UIViewController+.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 5/9/19.
//  Copyright © 2019 ChuoiChien. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

var _HandleCallbackHub: UInt8 = 100
extension UIViewController {
    
    var appDelegate: AppDelegate? {
        
        guard let app = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        return app
    }

    // add MBProgressHUD
    var mCurrentHUD : MBProgressHUD?
    {
        get {
            if (objc_getAssociatedObject(self, &_HandleCallbackHub) == nil) {
                self.mCurrentHUD = nil
            }
            if  objc_getAssociatedObject(self, &_HandleCallbackHub) is MBProgressHUD {
                return objc_getAssociatedObject(self, &_HandleCallbackHub) as? MBProgressHUD
            } else {
                return nil
                
            }
        }
        set {
            objc_setAssociatedObject(self, &_HandleCallbackHub, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func showHUD() {
        hideHUD()
        
        mCurrentHUD = MBProgressHUD.showAdded(to: AppDelegate.shareInstance.window!, animated: true)
        mCurrentHUD?.isUserInteractionEnabled = true
    }
    
    func hideHUD() {
        if mCurrentHUD != nil {
            mCurrentHUD?.hide(animated: true)
            mCurrentHUD = nil
        }
    }
}
