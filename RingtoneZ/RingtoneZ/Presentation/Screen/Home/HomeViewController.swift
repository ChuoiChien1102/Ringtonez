//
//  HomeViewController.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 11/7/20.
//

import UIKit
import Permission
import SwiftNotificationCenter

class HomeViewController: BaseViewController {

    @IBOutlet weak var viewPremium: UIView!
    
    @IBOutlet weak var viewContentHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var viewMaker: UIView!
    @IBOutlet weak var viewRecord: UIView!
    @IBOutlet weak var viewCategories: UIView!
    @IBOutlet weak var viewMyTone: UIView!
    
    let mediaLibrary: Permission = .mediaLibrary
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewPremium.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickPremium(_:)))
        viewPremium.addGestureRecognizer(tapGesture)
        
        viewContentHeightContraint.constant = WIDTH_DEVICE
        viewMaker.addGradient(colors: [UIColor.init(hex: "#2874CA").cgColor, UIColor.init(hex: "#30CFF0").cgColor], cornerRadius: viewMaker.frame.height/5)
        viewRecord.addGradient(colors: [UIColor.init(hex: "#BD005A").cgColor, UIColor.init(hex: "#F2004F").cgColor], cornerRadius: viewRecord.frame.height/5)
        viewCategories.addGradient(colors: [UIColor.init(hex: "#FD910E").cgColor, UIColor.init(hex: "#FEE002").cgColor], cornerRadius: viewCategories.frame.height/5)
        viewMyTone.addGradient(colors: [UIColor.init(hex: "#07A396").cgColor, UIColor.init(hex: "#01F09E").cgColor], cornerRadius: viewMyTone.frame.height/5)
        
        viewMaker.isUserInteractionEnabled = true
        let tapGestureMaker = UITapGestureRecognizer(target: self, action: #selector(clickMaker(_:)))
        viewMaker.addGestureRecognizer(tapGestureMaker)
        
        viewRecord.isUserInteractionEnabled = true
        let tapGestureRecord = UITapGestureRecognizer(target: self, action: #selector(clickRecord(_:)))
        viewRecord.addGestureRecognizer(tapGestureRecord)
        
        viewCategories.isUserInteractionEnabled = true
        let tapGestureCategories = UITapGestureRecognizer(target: self, action: #selector(clickCategories(_:)))
        viewCategories.addGestureRecognizer(tapGestureCategories)
        
        viewMyTone.isUserInteractionEnabled = true
        let tapGestureMyTone = UITapGestureRecognizer(target: self, action: #selector(clickMyTone(_:)))
        viewMyTone.addGestureRecognizer(tapGestureMyTone)
        
        Broadcaster.register(MediaPickerUpdate.self, observer: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func clickPremium(_ recognizer: UITapGestureRecognizer) {
        let vc = IAPViewController.newInstance()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func clickSetting(_ sender: Any) {
        let vc = SettingViewController.newInstance()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func clickMaker(_ recognizer: UITapGestureRecognizer) {
        self.checkMediaLibraryPermission {
            DispatchQueue.main.async {
                DNMediaPickerManager.shared.rootViewController = self
                DNMediaPickerManager.shared.presentMediaPicker()
            }
        }
    }
    @objc func clickRecord(_ recognizer: UITapGestureRecognizer) {
        let vc = RecordViewController.newInstance()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func clickCategories(_ recognizer: UITapGestureRecognizer) {
        let vc = CategoriesViewController.newInstance()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func clickMyTone(_ recognizer: UITapGestureRecognizer) {
        let vc = MyToneViewController.newInstance()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController {
    func checkMediaLibraryPermission(completed: @escaping () -> Void) {
        
        mediaLibrary.request { (status) in
            switch status {
            case .authorized:
                print("authorized")
                completed()
            case .denied:
                print("denied")
            case .disabled:
                print("disabled")
            case .notDetermined:
                print("not determined")
            }
        }
    }
}

extension HomeViewController : MediaPickerUpdate {
    
    func tunesMakerDidPickAudio(_ mediaObject: [String : Any]?) {
        guard let media = mediaObject else { return }
        guard let mediaURL = media["mediaUrl"] as? URL else { return }
        let vc = MakerViewController.newInstance()
        vc.audioPath = mediaURL
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
