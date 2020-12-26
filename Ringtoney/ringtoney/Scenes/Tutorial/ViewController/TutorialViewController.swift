//
//  TutorialViewController.swift
//  ringtoney
//
//  Created by dong ka on 03/12/2020.
//  Copyright (c) 2020 All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import CHIPageControl

class TutorialViewController: ViewController {
    
    //MARK:- Property
    private var headerView: BackNavigationView!
    private var collectionView: CollectionView!
    private var pageControl: CHIPageControlJaloro!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ENTER YOUR TITLE HERE"
        //Code here
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Code here
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Code here
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //Code here
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //Code here
    }
    
    
    //MARK:- Deinit
    deinit {
        log.debug("\(type(of: self)): Deinited")
    }
    
    //MARK:- Bind ViewModel
    override func bindViewModel() {
        super.bindViewModel()
        
        guard let viewModel = viewModel as? TutorialViewModel else { return }
        
        //Input
        let inputs = TutorialViewModel.Input(
            dismiss: headerView.backButton.rx.tap.asObservable()
        )
        
        //Outputs
        let output = viewModel.transform(input: inputs)
        
        output.items
            .drive(self.collectionView.rx.items(cellIdentifier: TutorialCell.identifier, cellType: TutorialCell.self)) { idx, element, cell in
                cell.backgroundColor = .clear
                cell.imageView.image = element.image
            }
            .disposed(by: bag)
        
        
        
    }
    
    //MARK:- UI
    override func makeUI() {
        super.makeUI()
        //Code here
        addHeaderView()
        addCollectionView()
        addPageControl()
    }
    
    override func updateUI() {
        
    }
    
    func addHeaderView() {
        headerView = BackNavigationView.init()
        stackView.addArrangedSubview(headerView)
        headerView.snp.makeConstraints { (make) in
            make.height.equalTo(50)
        }
        headerView.titleLabel.text = "Tutorial"
    }
    
    func addCollectionView() {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        //        flowLayout.itemSize = CGSize(width: 150, height: 50)
        
        collectionView = CollectionView.init(frame: self.view.frame, collectionViewLayout: flowLayout)
        
        collectionView.setCollectionViewLayout(flowLayout, animated: true)
        
        stackView.addArrangedSubview(collectionView)
        
        collectionView.register(TutorialCell.self, forCellWithReuseIdentifier: TutorialCell.identifier)
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.delegate = self
        
        collectionView.isPagingEnabled = true
        
    }
    
    func addPageControl() {
        
        let container = View()
        stackView.addArrangedSubview(container)
        container.snp.makeConstraints { (make) in
            make.height.equalTo(50)
        }
        
        
        pageControl = CHIPageControlJaloro(frame: CGRect(x: 0, y:0, width: 100, height: 20))
        
        container.addSubview(pageControl)
        pageControl.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
        
        pageControl.numberOfPages = 6
        pageControl.radius = 1
        pageControl.tintColor = UIColor.init(hex: "ffffff")
        pageControl.currentPageTintColor = UIColor.init(hex: "6DD5FA")
        pageControl.padding = 6
        pageControl.elementHeight = 2
    }
    
}

//MARK:- Extensition
extension TutorialViewController {
    
    
}

extension TutorialViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.bounds.width , height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.set(progress: indexPath.row, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if pageControl.currentPage == indexPath.row {
            self.pageControl.set(progress: collectionView.indexPath(for: collectionView.visibleCells.first!)!.row,
                                 animated: true)
        }
    }
}
