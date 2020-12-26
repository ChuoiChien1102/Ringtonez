//
//  MyToneCell.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 11/27/20.
//

import UIKit
import AVFoundation

class MyToneCell: UITableViewCell {
    
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configUI(ringtone: RingToneModel) -> Void {
        lbName.text = ringtone.name
        if ringtone.isSelected {
            if ringtone.isPlay {
                btnPlay.isSelected = true
            } else {
                btnPlay.isSelected = false
            }
            if ringtone.progress != nil {
                progressView.progress = ringtone.progress!
            }
        } else {
            btnPlay.isSelected = false
            progressView.progress = 0
        }
    }
}
