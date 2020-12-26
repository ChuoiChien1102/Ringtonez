//
//  LoadingManager.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 12/4/20.
//

import Foundation
import JGProgressHUD

class LoadingManager: NSObject {
    
    static let hud = JGProgressHUD()
    
    static func show( in vc: UIViewController ) {
        hud.textLabel.text = "Loading"
        hud.show(in: vc.view)
    }
    
    static func hide() {
        hud.dismiss(afterDelay: .init(0), animated: true)
    }
    
    
    static func success( in vc: UIViewController ) {
        let successHUD = JGProgressHUD()
        successHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
        successHUD.show(in: vc.view)
        successHUD.dismiss(afterDelay: 1.7)
    }
}
