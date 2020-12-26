//
//  SettingViewController.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 11/8/20.
//

import UIKit
import SafariServices
import SwiftRater

class SettingViewController: BaseViewController {

    @IBOutlet weak var viewInstall: UIView!
    @IBOutlet weak var viewPolicy: UIView!
    @IBOutlet weak var viewTerm: UIView!
    @IBOutlet weak var viewRate: UIView!
    @IBOutlet weak var viewTellFriend: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        viewInstall.isUserInteractionEnabled = true
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(clickInstall(_:)))
        viewInstall.addGestureRecognizer(tapGesture1)
        
        viewPolicy.isUserInteractionEnabled = true
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(clickPolicy(_:)))
        viewPolicy.addGestureRecognizer(tapGesture2)
        
        viewTerm.isUserInteractionEnabled = true
        let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(clickTerm(_:)))
        viewTerm.addGestureRecognizer(tapGesture3)
        
        viewRate.isUserInteractionEnabled = true
        let tapGesture4 = UITapGestureRecognizer(target: self, action: #selector(clickRate(_:)))
        viewRate.addGestureRecognizer(tapGesture4)
        
        viewTellFriend.isUserInteractionEnabled = true
        let tapGesture5 = UITapGestureRecognizer(target: self, action: #selector(clickTellFriend(_:)))
        viewTellFriend.addGestureRecognizer(tapGesture5)
    }
    
    @IBAction func clickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func clickInstall(_ recognizer: UITapGestureRecognizer) {
        let vc = TutorialViewController.newInstance()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @objc func clickPolicy(_ recognizer: UITapGestureRecognizer) {
        if let url = URL(string: App.termOfUse) {
            if #available(iOS 11.0, *) {
                let config = SFSafariViewController.Configuration()
                config.entersReaderIfAvailable = true
                let vc = SFSafariViewController(url: url, configuration: config)
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    @objc func clickTerm(_ recognizer: UITapGestureRecognizer) {
        if let url = URL(string: App.termOfUse) {
            if #available(iOS 11.0, *) {
                let config = SFSafariViewController.Configuration()
                config.entersReaderIfAvailable = true
                let vc = SFSafariViewController(url: url, configuration: config)
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    @objc func clickRate(_ recognizer: UITapGestureRecognizer) {
        SwiftRater.rateApp(host: self)
    }
    
    @objc func clickTellFriend(_ recognizer: UITapGestureRecognizer) {
        if let urlStr = NSURL(string: App.ituneURL) {
            let objectsToShare = [urlStr]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                if let popup = activityVC.popoverPresentationController {
                    popup.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
                    popup.sourceView = self.view
                    popup.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
                }
            }
            activityVC.modalPresentationStyle = .fullScreen
            self.present(activityVC, animated: true, completion: nil)
        }
    }
}
