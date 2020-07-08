//
//  CategoriesCollectionViewCell.swift
//  Forloop
//
//  Created by Tecorb Techonologies on 16/12/19.
//  Copyright © 2019 Tecorb. All rights reserved.
//

import UIKit

class CategoriesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var backView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        CommonClass.makeViewCircularWithCornerRadius(self.backView, borderColor: .clear, borderWidth: 0, cornerRadius: 10)
        // Initialization code
    }

}
