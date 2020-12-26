//
//  CatalogCell.swift
//  ringtoney
//
//  Created by dong ka on 11/3/20.
//

import Foundation

class CatalogCell: TableViewCell {
    
    let stackView = StackView().then {
        $0.axis = .horizontal
        $0.spacing = 16
    }
    
    var titleLabel = Label().then {
        $0.font = FontsManager.nasalization.font(size: 15)
        $0.numberOfLines = 1
        $0.textColor = .white
    }

    let icon = ImageView().then {
        $0.image = R.image.icon_cell_category()
        $0.contentMode = .scaleAspectFit
    }
    
    override func makeUI() {
        super.makeUI()
        addStackView()
        addIcon()
        addTitleLabel()
    }
    
    func addStackView() {
        containerView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    func addIcon() {
        stackView.addArrangedSubview(icon)
        icon.snp.makeConstraints { (make) in
            make.width.equalTo(45)
        }
    }
    
    func addTitleLabel() {
        stackView.addArrangedSubview(titleLabel)
    }
    
    override func bind(to viewModel: TableViewCellViewModel) {
        super.bind(to: viewModel)
        
        guard let viewModel = viewModel as? CatalogCellViewModel else { return }
        viewModel.title.bind(to: titleLabel.rx.text).disposed(by: cellDisposeBag)
        
    }
    
}
