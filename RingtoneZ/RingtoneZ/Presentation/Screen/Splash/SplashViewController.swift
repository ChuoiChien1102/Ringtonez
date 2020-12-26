//
//  SplashViewController.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 12/5/20.
//

import UIKit

class SplashViewController: BaseViewController {

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        indicator.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            if (UserDefaults.standard.bool(forKey: KEY_IS_SKIP) == true) {
                let vc = IAPViewController.newInstance()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            } else {
                let navi = UINavigationController(rootViewController: Intro1ViewController.newInstance(), navigationBarClass: NavigationBar.self)
                self.appDelegate?.changeRootViewController(navi)
            }
        }
    }
}
