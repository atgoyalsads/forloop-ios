//
//  TextOutgoingTableViewCell.swift
//  ViybApp
//
//  Created by Tecorb Techonologies on 19/08/19.
//  Copyright © 2019 Parikshit. All rights reserved.
//

import UIKit

class TextOutgoingTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
