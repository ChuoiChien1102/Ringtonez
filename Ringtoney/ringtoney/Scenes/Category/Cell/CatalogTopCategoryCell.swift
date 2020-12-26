//
//  CatalogTopCategoryCell.swift
//  ringtoney
//
//  Created by dong ka on 11/3/20.
//

import Foundation

class CatalogTopCategoryCell: TableViewCell {
    
    var itemSelected: ((Category) -> Void)?
    
    let stackView = StackView().then {
        $0.axis = .horizontal
        $0.spacing = 16
    }
    
    var collectionView: CollectionView!
    var categories: [Category] = []
    
    
    override func makeUI() {
        super.makeUI()
        addStackView()
        addCollectionView()
    }
    
    override func updateUI() {
        super.updateUI()
    }
    
    func addStackView() {
        containerView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }
    
    
    func addCollectionView() {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 150, height: 50)
        
        collectionView = CollectionView.init(frame: self.frame, collectionViewLayout: flowLayout)
        
        collectionView.setCollectionViewLayout(flowLayout, animated: true)
        
        stackView.addArrangedSubview(collectionView)
        
        collectionView.register(TrendingCell.self, forCellWithReuseIdentifier: TrendingCell.identifier)
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.contentInset = UIEdgeInsets.init(top: 0, left: 16, bottom: 0, right: 0)
        collectionView.delegate = self
        
    }
    
    override func bind(to viewModel: TableViewCellViewModel) {
        super.bind(to: viewModel)
        
        guard let viewModel = viewModel as? CatalogTopCategoryCellViewModel else { return }
        
        categories = viewModel.categories.value
        
        viewModel.categories.asDriver(onErrorJustReturn: [])
            .drive(collectionView.rx
                    .items(
                        cellIdentifier: TrendingCell.identifier,
                        cellType: TrendingCell.self)) { indexPath, element, cell in
                cell.titleLabel.text = element.title
            }
            .disposed(by: cellDisposeBag)
    }
    
}

extension CatalogTopCategoryCell: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if categories.isEmpty == false {
            let item = categories[indexPath.row]
            self.itemSelected?(item)
            log.debug("Selected row")
        }

    }
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    //        return 0
    //    }
    //
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    //        return 16
    //    }
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //        return CGSize.init(width: 140, height: collectionView.bounds.height)
    //    }
    
}
