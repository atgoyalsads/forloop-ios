//
//  TipTableViewCell.swift
//  Forloop
//
//  Created by Tecorb Techonologies on 13/12/19.
//  Copyright © 2019 Tecorb. All rights reserved.
//

import UIKit

protocol TipTableViewCellDelegate {
    func tipTableViewCellDelegate(indexpath:IndexPath,success:Bool)
}

class TipTableViewCell: UITableViewCell {
    @IBOutlet weak var collectionview: UICollectionView!
    var tips = [String]()
    var selectIndex = -1
    var delegate:TipTableViewCellDelegate?
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
        let tipCollectionViewCellNib = UINib(nibName: "TipCollectionViewCell", bundle: nil)
        self.collectionview.register(tipCollectionViewCellNib, forCellWithReuseIdentifier: "TipCollectionViewCell")
        self.collectionview.backgroundColor  = .clear
        self.collectionview.dataSource = self
        self.collectionview.delegate = self
    }
    
    func setCollectionCiewData(tips:[String],selectIndex:Int){
        self.tips = tips
        self.selectIndex = selectIndex
        self.collectionview.dataSource = self
        self.collectionview.delegate = self
        self.collectionview.reloadData()
    }

    
}

extension TipTableViewCell: UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.tips.count == 4{
            let width = self.collectionview.frame.width / 4 - 5
            let height = self.collectionview.frame.height
            return CGSize(width: width , height: height)
        }else{
            let width = self.collectionview.frame.width / 4.5
            let height = self.collectionview.frame.height
            return CGSize(width: width , height: height)
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tips.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TipCollectionViewCell", for: indexPath) as! TipCollectionViewCell
        cell.tipLabel.text = self.tips[indexPath.item]
        cell.backView.backgroundColor = (selectIndex == indexPath.item) ? appColor.appBlueColor : appColor.white
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.selectIndex == indexPath.item{
            return
        }
        self.selectIndex = indexPath.item
        self.delegate?.tipTableViewCellDelegate(indexpath: indexPath, success: true)
        self.collectionview.reloadData()
    }
    
    
    
}

