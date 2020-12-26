//
//  MytoneCell.swift
//  ringtoney
//
//  Created by dong ka on 11/5/20.
//

import Foundation

class MytoneCell : DefaultRingtoneCell {
    
    
    override func bind(to viewModel: TableViewCellViewModel) {
        super.bind(to: viewModel)

        guard let viewModel = viewModel as? MyToneCellViewModel else { return }
        viewModel.title.bind(to: self.titleLabel.rx.text).disposed(by: cellDisposeBag)
        viewModel.isPlay.bind(to: self.playButton.rx.isSelected).disposed(by: cellDisposeBag)
        
        viewModel.progress
            .subscribe(onNext:{[weak self] value in
                guard let self = self else { return }
                var newWidth = (self.bounds.width - 120) * CGFloat(value)
                newWidth = newWidth == 0  ? 1 : newWidth
                //log.debug("--->\(value)")
                self.progressView.snp.remakeConstraints { (make) in
                    make.bottom.equalToSuperview().inset(12)
                    make.height.equalTo(2)
                    make.leading.equalToSuperview().offset(84)
                    make.width.equalTo(newWidth)
                }
            })
            .disposed(by: cellDisposeBag)
        
    }
    
}
