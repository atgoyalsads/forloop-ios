//
//  PaymentsOptionsTableViewCell.swift
//  Fuel Delivery
//
//  Created by Parikshit on 02/10/19.
//  Copyright © 2019 Nakul Sharma. All rights reserved.
//

import UIKit
import MGSwipeTableCell


class PaymentsOptionsTableViewCell:  MGSwipeTableCell {
    
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var cardNumberLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
