//
//  LearnerCategoryTableViewCell.swift
//  Forloop
//
//  Created by Tecorb on 27/03/20.
//  Copyright © 2020 Tecorb. All rights reserved.
//

import UIKit

class LearnerCategoryTableViewCell: UITableViewCell {
    @IBOutlet weak var categoryLabel:UILabel!
    @IBOutlet weak var categoryimage:UIImageView!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
