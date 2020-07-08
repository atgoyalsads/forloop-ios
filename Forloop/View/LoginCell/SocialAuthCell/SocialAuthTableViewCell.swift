//
//  SocialAuthTableViewCell.swift
//  Forloop
//
//  Created by Tecorb on 05/12/19.
//  Copyright © 2019 Tecorb. All rights reserved.
//

import UIKit

class SocialAuthTableViewCell: UITableViewCell {
    @IBOutlet weak var facebookButton:UIButton!
    @IBOutlet weak var gmailButton:UIButton!
    @IBOutlet weak var amazonkButton:UIButton!
    @IBOutlet weak var showLabel:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
