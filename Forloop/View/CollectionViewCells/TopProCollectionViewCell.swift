//
//  TopProCollectionViewCell.swift
//  Forloop
//
//  Created by Tecorb Techonologies on 13/12/19.
//  Copyright © 2019 Tecorb. All rights reserved.
//

import UIKit

class TopProCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var topperImage: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var topperName: UILabel!
    @IBOutlet weak var topperDescription: UILabel!
    @IBOutlet weak var ratinglabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var ratingView: NKFloatRatingView!
    @IBOutlet weak var lessonsLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        CommonClass.makeViewCircularWithRespectToHeight(topperImage, borderColor: .clear, borderWidth: 0)
    }

}
