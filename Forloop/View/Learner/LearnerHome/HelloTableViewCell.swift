//
//  HelloTableViewCell.swift
//  Forloop
//
//  Created by Tecorb Techonologies on 13/12/19.
//  Copyright © 2019 Tecorb. All rights reserved.
//

import UIKit

class HelloTableViewCell: UITableViewCell {

    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var chooseCategoryLabel: UILabel!
    @IBOutlet weak var seeAllButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
