//
//  CallInformationTableViewCell.swift
//  Forloop
//
//  Created by Tecorb Techonologies on 11/12/19.
//  Copyright © 2019 Tecorb. All rights reserved.
//

import UIKit

class CallInformationTableViewCell: UITableViewCell {

    @IBOutlet weak var callerName: UILabel!
    @IBOutlet weak var callerStatusLabel: UILabel!
    @IBOutlet weak var callerStatusView: UIView!
    @IBOutlet weak var chargeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
