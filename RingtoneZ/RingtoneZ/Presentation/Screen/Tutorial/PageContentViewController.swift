//
//  PageContentViewController.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 12/5/20.
//

import UIKit
class PageContentViewController: UIViewController {
    
    @IBOutlet weak var imgBG: UIImageView!
    
    var pageIndex = 0
    var index = 0
    var nameImage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgBG.image = UIImage(named: nameImage)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
