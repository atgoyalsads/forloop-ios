//
//  SelectCategoriesCollectionViewCell.swift
//  ambiview
//
//  Created by Tecorb Techonologies on 09/12/19.
//  Copyright © 2019 Tecorb Techonologies. All rights reserved.
//

import UIKit

class SelectCategoriesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var categoryButton : UIButton!
    @IBOutlet weak var closeButton : UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        CommonClass.makeViewCircularWithRespectToHeight(self.categoryButton, borderColor: .clear, borderWidth: 0)
        // Initialization code
    }
    override func layoutSubviews() {
    CommonClass.makeViewCircularWithRespectToHeight(self.categoryButton, borderColor: .clear, borderWidth: 0)

    }

}
