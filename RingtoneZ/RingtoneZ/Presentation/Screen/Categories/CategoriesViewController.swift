//
//  CategoriesViewController.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 11/9/20.
//

import UIKit

class CategoriesViewController: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var listCategory = [CategoryModel]()
    var currentPage = 1
    var last_page = 1
    
    private let itemsPerRow: CGFloat = 3
    fileprivate let sectionInset = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        collectionView.register(UINib(nibName: "CategoriesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoriesCollectionViewCell")
        
        var param = [String: Any]()
        param["app"] = "z"
        param["page"] = String(currentPage)
        
        LoadingManager.show(in: self)
        ApiSevice.listCategories(param) { (response, error) in
            LoadingManager.hide()
            if (error == nil) {
                self.last_page = response!.last_page
                self.listCategory = (response?.data)!
                self.collectionView.reloadData()
            }
        }
    }
    
    @IBAction func clickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension CategoriesViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInset
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInset.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height_title = 50
        
        let paddingSpace = sectionInset.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: (widthPerItem + CGFloat(height_title)))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if listCategory.count > 0 && indexPath.row == listCategory.count - 1 && currentPage < last_page {
            // load more
            currentPage += 1
            var param = [String: Any]()
            param["app"] = "z"
            param["page"] = String(currentPage)
            
            LoadingManager.show(in: self)
            ApiSevice.listCategories(param) { (response, error) in
                LoadingManager.hide()
                if (error == nil) {
                    guard let arr = response?.data else {return}
                    for item in arr {
                        self.listCategory.append(item)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) ->
    UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionViewCell", for: indexPath) as! CategoriesCollectionViewCell
        
        if listCategory.count > 0 {
            let item = listCategory[indexPath.row]
            cell.configUI(category: item)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailCategoryViewController.newInstance()
        let item = listCategory[indexPath.row]
        vc.titleCategory = item.name
        vc.categoryID = String(item.id)
        navigationController?.pushViewController(vc, animated: true)
    }
}
