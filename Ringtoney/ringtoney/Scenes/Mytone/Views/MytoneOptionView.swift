//
//  MytoneOptionView.swift
//  ringtoney
//
//  Created by dong ka on 11/5/20.
//

import Foundation
class MytoneOptionView: View {
    
    let stackView = StackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fill
    }
    
    let recordButton = Button().then {
        $0.setImage(R.image.icon_mytone_record(), for: .normal)
        $0.imageEdgeInsets = UIEdgeInsets.init(top: -8, left: -8, bottom: -8, right: -8)
    }
    
    let ringtoneButton = RingtoneButton().then {
        $0.setTitle("Ringtone", for: .normal)
    }
    let trackButton = RingtoneButton().then {
        $0.setTitle("Tracks", for: .normal)

    }


    //icon_mytone_record
    override func makeUI() {
        super.makeUI()
        addStackView()
        addRingtoneAndTrackButton()
        addRecordButton()

    }
    
    func addStackView() {
        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    func addRecordButton() {
        
        let container = View()
        stackView.addArrangedSubview(container)
        container.snp.makeConstraints { (make) in
            make.width.equalTo(52)
        }
        
        container.addSubview(recordButton)
        recordButton.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func addRingtoneAndTrackButton() {
        
        let stack = StackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 16
        
        stackView.addArrangedSubview(stack)
        
        stack.addArrangedSubview(ringtoneButton)
        stack.addArrangedSubview(trackButton)
        
    }
    

    
}
