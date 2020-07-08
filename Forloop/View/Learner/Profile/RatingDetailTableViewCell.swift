//
//  RatingDetailTableViewCell.swift
//  Forloop
//
//  Created by Tecorb Techonologies on 12/12/19.
//  Copyright © 2019 Tecorb. All rights reserved.
//

import UIKit

class RatingDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var timeConstraint: NSLayoutConstraint!
    @IBOutlet weak var reviewerNameLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
