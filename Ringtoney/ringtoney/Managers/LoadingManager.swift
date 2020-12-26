//
//  LoadingManager.swift
//  ringtoney
//
//  Created by dong ka on 18/11/2020.
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
