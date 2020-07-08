//
//  NumberOfCallTableViewCell.swift
//  Forloop
//
//  Created by Tecorb Techonologies on 12/12/19.
//  Copyright © 2019 Tecorb. All rights reserved.
//

import UIKit

class NumberOfCallTableViewCell: UITableViewCell {

    @IBOutlet weak var imageOfcell: UIImageView!
    @IBOutlet weak var headerOfCell: UILabel!
    @IBOutlet weak var dollarLabel: UILabel!
    @IBOutlet weak var chargeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
