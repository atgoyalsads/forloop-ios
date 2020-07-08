//
//  TopProUsersTableViewCell.swift
//  Forloop
//
//  Created by Tecorb on 10/01/20.
//  Copyright © 2020 Tecorb. All rights reserved.
//

import UIKit

class TopProUsersTableViewCell: UITableViewCell {
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        CommonClass.makeViewCircular(self.topperImage)
    }
    
}
