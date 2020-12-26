//
//  DetailCategoryCell.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 12/1/20.
//

import UIKit
import AVFoundation

class DetailCategoryCell: UITableViewCell {
    
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var btnDownload: UIButton!
    
    
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
        if ringtone.isDowloadDone {
            btnDownload.isSelected = true
            btnDownload.isUserInteractionEnabled = false
        } else {
            btnDownload.isSelected = false
            btnDownload.isUserInteractionEnabled = true
        }
    }
}
