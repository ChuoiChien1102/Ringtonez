//
//  Intro2ViewController.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 11/5/20.
//

import UIKit

class Intro2ViewController: BaseViewController {
    
    @IBOutlet weak var btnNext: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnNext.applyGradient(colors: [UIColor.init(hex: "#9138FD").cgColor, UIColor.init(hex: "#E500BB").cgColor])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func clickNext(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: KEY_IS_SKIP)
        let vc = IAPViewController.newInstance()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}

extension Intro2ViewController {
    
    
}
