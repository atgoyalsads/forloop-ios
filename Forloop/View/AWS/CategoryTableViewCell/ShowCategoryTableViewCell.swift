//
//  CategoryTableViewCell.swift
//  Forloop
//
//  Created by Tecorb on 08/01/20.
//  Copyright © 2020 Tecorb. All rights reserved.
//

import UIKit

class ShowCategoryTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var selectButton:UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
