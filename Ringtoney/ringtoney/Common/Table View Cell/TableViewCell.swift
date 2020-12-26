//
//  TableViewCell.swift
//  ringtoney
//
//  Created by dong ka on 10/29/20.
//

import Foundation

class TableViewCell: UITableViewCell {
    
    var cellDisposeBag = DisposeBag()
    var isSelection = false
    
    var containerView: View = View().then {
        $0.backgroundColor = .clear
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellDisposeBag = DisposeBag()
    }
    
    func makeUI() {
        layer.masksToBounds = true
        selectionStyle = .none
        backgroundColor = .clear
        
        updateUI()
        
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    
    func updateUI() {
        setNeedsDisplay()
    }

    func bind(to viewModel: TableViewCellViewModel) {

    }
}
