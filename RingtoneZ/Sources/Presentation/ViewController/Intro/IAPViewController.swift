//
//  IAPViewController.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 11/5/20.
//

import UIKit

class IAPViewController: UIViewController {
    
    @IBOutlet weak var btnNext: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnNext.applyGradient(colors: [UIColor.init(hex: "#9138FD").cgColor, UIColor.init(hex: "#E500BB").cgColor])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func clickNext(_ sender: Any) {
        
    }
}

extension IAPViewController {
    
    
}
