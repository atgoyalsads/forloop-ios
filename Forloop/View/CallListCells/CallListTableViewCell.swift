//
//  CallListTableViewCell.swift
//  Forloop
//
//  Created by Tecorb Techonologies on 10/12/19.
//  Copyright © 2019 Tecorb. All rights reserved.
//

import UIKit

class CallListTableViewCell: UITableViewCell {

    @IBOutlet weak var callerImage: UIImageView!
    @IBOutlet weak var callerNameLabel: UILabel!
    @IBOutlet weak var callDurationLabel: UILabel!
    @IBOutlet weak var callDateLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        CommonClass.makeViewCircular(self.callerImage)
    }
    
}
