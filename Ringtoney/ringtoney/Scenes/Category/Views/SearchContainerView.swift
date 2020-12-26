//
//  SearchContainerView.swift
//  ringtoney
//
//  Created by dong ka on 11/3/20.
//

import Foundation
class SearchContainerView: View {
    
    var searchBar = SearchBar()
    
    var stackView = StackView()
    
    override func makeUI() {
        super.makeUI()
        self.backgroundColor = UIColor.clear
        addStackView()
        addSearchBar()
        
        searchBar.textField.doneAccessory = true
        
    }
    
    func addStackView() {
        self.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func addSearchBar() {
        stackView.addArrangedSubview(searchBar)
    }
    
}
