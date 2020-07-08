//
//  CategoryTableViewCell.swift
//  Forloop
//
//  Created by Tecorb Techonologies on 16/12/19.
//  Copyright © 2019 Tecorb. All rights reserved.
//

import UIKit

protocol CategoryTableViewCellDelegate {
    func categoryTableViewCell(indexPath:IndexPath,category:CategoryModel)
}

class CategoryTableViewCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    var categories = [CategoryModel]()
    var delegate:CategoryTableViewCellDelegate?
    var selectIndex = -1
    override func awakeFromNib() {
        super.awakeFromNib()
        self.registerCells()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func registerCells() {
        let categoriesCollectionViewCellNib = UINib(nibName: "CategoriesCollectionViewCell", bundle: nil)
        self.collectionView.register(categoriesCollectionViewCellNib, forCellWithReuseIdentifier: "CategoriesCollectionViewCell")
        self.collectionView.backgroundColor  = .clear
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    
    func setCategoryData(categories:[CategoryModel]){
        self.categories = categories
        self.collectionView.reloadData()

    }
    
}

extension CategoryTableViewCell: UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGFloat(120)
        return CGSize(width: size , height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionViewCell", for: indexPath) as! CategoriesCollectionViewCell
        let category = categories[indexPath.item]
        cell.categoryLabel.text = category.title.uppercased()
        cell.backView.backgroundColor = (selectIndex == indexPath.item) ? appColor.gray : .clear
        switch indexPath.item % 4 {
        case 0:
            cell.categoryImage.image = UIImage(named: "Group1")
        case 1:
            cell.categoryImage.image = UIImage(named: "Group2")
        case 2:
            cell.categoryImage.image = UIImage(named: "Group3")
        case 3:
            cell.categoryImage.image = UIImage(named: "Group4")
        default:
            cell.categoryImage.image = UIImage(named: "Group1")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.categories.count == 0 {return}
        self.selectIndex = indexPath.item
        self.delegate?.categoryTableViewCell(indexPath: indexPath, category: self.categories[indexPath.item])
        self.collectionView.reloadData()
    }
    
}
