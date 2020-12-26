//
//  SearchBar.swift
//  ringtoney
//
//  Created by dong ka on 11/3/20.
//

import Foundation
class SearchBar: UISearchBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeUI() {
        clearBackgroundColor()
        setupTextFieldSearchBar()
        
        //Text offset : https://stackoverflow.com/questions/6792495/how-can-i-change-a-uitextfield-position-in-uisearchbar
        
        self.searchTextPositionAdjustment = UIOffset(horizontal: 5, vertical: 0)

        UITextField.appearance(whenContainedInInstancesOf:
                                [SearchBar.self])
            .defaultTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.init(hexString: "FFFFFF",withAlpha: 1)!,
                NSAttributedString.Key.font: FontsManager.nasalization.font(size: 14)
            ]
        
        self.setImage(R.image.icon_search(),
                      for: UISearchBar.Icon.search, state: .normal)
        
        UITextField.appearance(whenContainedInInstancesOf:
                                [SearchBar.self])
            .attributedPlaceholder =
            NSAttributedString(
                string: "Search ringtone",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.init(hexString: "6A72A0",withAlpha: 0.46)!,
                NSAttributedString.Key.font: FontsManager.nasalization.font(size: 14)
            ])

    }
    
    private func setupTextFieldSearchBar() {
        self.tintColor = .white
        if #available(iOS 13.0, *) {
            self.searchTextField.backgroundColor = UIColor.init(hexString: "151824")
        } else {
            self.setTextField(color: UIColor.init(hexString: "151824"))
        }
    }
    
    private func clearBackgroundColor() {
        guard let UISearchBarBackground: AnyClass = NSClassFromString("UISearchBarBackground") else { return }
        for view in self.subviews {
            for subview in view.subviews where subview.isKind(of: UISearchBarBackground) {
                subview.alpha = 0
            }
        }
        
    }
    
    
}

extension SearchBar {
    func getTextField() -> UITextField? { return value(forKey: "searchField") as? UITextField }
    func setTextField(color: UIColor) {
        guard let textField = getTextField() else { return }
        switch searchBarStyle {
        case .minimal:
            textField.layer.backgroundColor = color.cgColor
            textField.layer.cornerRadius = 6
        case .prominent, .default: textField.backgroundColor = color
        @unknown default: break
        }
    }
}
