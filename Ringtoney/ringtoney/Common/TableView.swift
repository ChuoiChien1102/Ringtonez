//
//  TableView.swift
//  ringtoney
//
//  Created by dong ka on 10/29/20.
//

import Foundation

class TableView: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        makeUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeUI() {
        self.backgroundColor = .clear
    }
    
    
}
