//
//  SelectCategoriesTableViewCell.swift
//  ambiview
//
//  Created by Tecorb Techonologies on 09/12/19.
//  Copyright © 2019 Tecorb Techonologies. All rights reserved.
//

import UIKit


protocol SelectCategoriesDelegate {
    func selectCategories(contactCell cell:SelectCategoriesTableViewCell,selectIndex:Int,success:Bool)
    func deleteCategory(contactCell cell:SelectCategoriesTableViewCell,indexPath:IndexPath,success:Bool,deleteCategory:CategoryModel)
}

class SelectCategoriesTableViewCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    var delegate: SelectCategoriesDelegate?

    var nameOfCategories = ["HTML and CSS","Javascript","Server Side","Programming","Web Building","XML Tutorials","Server Side","Programming"]
    var categories = [CategoryModel]()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.registerCells()
        // Initialization code
    }
            
    func registerCells() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 10
        collectionView.collectionViewLayout = flowLayout
        let SelectCategoriesCollectionViewCellNib = UINib(nibName: "SelectCategoriesCollectionViewCell", bundle: nil)
        self.collectionView.register(SelectCategoriesCollectionViewCellNib, forCellWithReuseIdentifier: "SelectCategoriesCollectionViewCell")
        self.collectionView.backgroundColor  = .clear
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    func loadCategories(categories:[CategoryModel]){
        self.categories = categories
        self.collectionView.reloadData()
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    

}

extension SelectCategoriesTableViewCell: UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.collectionView.frame.width / 3
        let height = CGFloat(50)
        return CGSize(width: width , height: height)
    }
            
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories.count//nameOfCategories.count
    }
            
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectCategoriesCollectionViewCell", for: indexPath) as! SelectCategoriesCollectionViewCell
//        cell.categoryButton.setTitle(nameOfCategories[indexPath.row], for: .normal)
        let category = self.categories[indexPath.item]
        cell.categoryButton.setTitle(category.title, for: .normal)
        cell.categoryButton.isUserInteractionEnabled  = false
        cell.closeButton.addTarget(self, action: #selector(onClickDeleteButton(_:)), for: .touchUpInside)

        return cell
    }
    
    @IBAction func onClickDeleteButton(_ sender:UIButton){
        if let indexPath =  sender.collectionViewIndexPath(collectionView){
           if self.categories.count != 0 {
            let catgry = self.categories[indexPath.item]

            self.delegate?.deleteCategory(contactCell: self, indexPath: indexPath, success: true, deleteCategory:catgry)
            //                self.categories.remove(at: indexPath.item)
            //                self.collectionView.reloadData()
            }
        }
            
        
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if self.categories.count == 0{return}
//        self.delegate?.selectCategories(contactCell: self, selectIndex: indexPath.item, success: true)
//
//
//    }

            
}
