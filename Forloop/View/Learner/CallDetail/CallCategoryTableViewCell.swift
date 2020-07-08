//
//  CallCategoryTableViewCell.swift
//  Forloop
//
//  Created by Tecorb Techonologies on 12/12/19.
//  Copyright © 2019 Tecorb. All rights reserved.
//

import UIKit

class CallCategoryTableViewCell: UITableViewCell {
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var categoryChargeLabel: UILabel!
    @IBOutlet weak var dollarLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
